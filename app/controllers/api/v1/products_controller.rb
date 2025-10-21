# frozen_string_literal: true

module Api
  module V1
    class ProductsController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_product, only: %i[show update destroy]

      SORT_FIELDS = %w[name price created_at].freeze

      def index
        authorize Product
        products = Product.includes(:category)
                           .search(params[:q])
                           .yield_self { |scope| params[:category_id].present? ? scope.where(category_id: params[:category_id]) : scope }
                           .order(sort_params)
                           .page(params[:page])
                           .per(params[:per_page])
        render_success(data: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer))
      end

      def show
        authorize @product
        render_success(data: ProductSerializer.new(@product).serializable_hash)
      end

      def create
        product = Product.new(product_params)
        authorize product
        if product.save
          render_success(data: ProductSerializer.new(product).serializable_hash, message: 'Product created', status: :created)
        else
          render_error(errors: product.errors.full_messages)
        end
      end

      def update
        authorize @product
        if @product.update(product_params)
          render_success(data: ProductSerializer.new(@product).serializable_hash, message: 'Product updated')
        else
          render_error(errors: @product.errors.full_messages)
        end
      end

      def destroy
        authorize @product
        @product.destroy
        render_success(data: {}, message: 'Product deleted')
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :slug, :price, :sale_price, :description, :stock, :category_id, :status, :weight, :sku, :brand)
      end

      def sort_params
        return { created_at: :desc } if params[:sort].blank?

        field, direction = params[:sort].split(':')
        field = field.to_s
        direction = direction == 'asc' ? :asc : :desc
        return { created_at: :desc } unless SORT_FIELDS.include?(field)

        { field.to_sym => direction }
      end
    end
  end
end
