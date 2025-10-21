# frozen_string_literal: true

module Api
  module V1
    class VariantsController < Api::V1::BaseController
      before_action :set_product
      before_action :set_variant, only: %i[update destroy]

      def index
        authorize @product, :show?
        render_success(data: ActiveModelSerializers::SerializableResource.new(@product.variants, each_serializer: VariantSerializer))
      end

      def create
        authorize @product, :update?
        variant = @product.variants.new(variant_params)
        if variant.save
          render_success(data: VariantSerializer.new(variant).serializable_hash, message: 'Variant created', status: :created)
        else
          render_error(errors: variant.errors.full_messages)
        end
      end

      def update
        authorize @product, :update?
        if @variant.update(variant_params)
          render_success(data: VariantSerializer.new(@variant).serializable_hash, message: 'Variant updated')
        else
          render_error(errors: @variant.errors.full_messages)
        end
      end

      def destroy
        authorize @product, :update?
        @variant.destroy
        render_success(data: {}, message: 'Variant deleted')
      end

      private

      def set_product
        @product = Product.find(params[:product_id])
      end

      def set_variant
        @variant = @product.variants.find(params[:id])
      end

      def variant_params
        params.require(:variant).permit(:option_name, :option_value, :price, :stock)
      end
    end
  end
end
