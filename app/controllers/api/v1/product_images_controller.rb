# frozen_string_literal: true

module Api
  module V1
    class ProductImagesController < Api::V1::BaseController
      before_action :set_product
      before_action :set_image, only: :destroy

      def index
        authorize @product, :show?
        render_success(data: ActiveModelSerializers::SerializableResource.new(@product.product_images, each_serializer: ProductImageSerializer))
      end

      def create
        authorize @product, :update?
        image = @product.product_images.new(product_image_params)
        image.image.attach(params[:image]) if params[:image]
        if image.save
          render_success(data: ProductImageSerializer.new(image).serializable_hash, message: 'Image uploaded', status: :created)
        else
          render_error(errors: image.errors.full_messages)
        end
      end

      def destroy
        authorize @product, :update?
        @image.destroy
        render_success(data: {}, message: 'Image removed')
      end

      private

      def set_product
        @product = Product.find(params[:product_id])
      end

      def set_image
        @image = @product.product_images.find(params[:id])
      end

      def product_image_params
        params.require(:product_image).permit(:image_url)
      end
    end
  end
end
