# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_category, only: %i[show update destroy]

      def index
        categories = Category.includes(:children).all
        render_success(data: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer))
      end

      def show
        render_success(data: CategorySerializer.new(@category).serializable_hash)
      end

      def create
        category = Category.new(category_params)
        authorize category
        if category.save
          render_success(data: CategorySerializer.new(category).serializable_hash, message: 'Category created', status: :created)
        else
          render_error(errors: category.errors.full_messages)
        end
      end

      def update
        authorize @category
        if @category.update(category_params)
          render_success(data: CategorySerializer.new(@category).serializable_hash, message: 'Category updated')
        else
          render_error(errors: @category.errors.full_messages)
        end
      end

      def destroy
        authorize @category
        @category.destroy
        render_success(data: {}, message: 'Category deleted')
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :parent_id, :slug, :description)
      end
    end
  end
end
