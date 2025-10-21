# frozen_string_literal: true

module Api
  module V1
    class CartItemsController < Api::V1::BaseController
      def index
        items = current_user.cart_items.includes(:product)
        render_success(data: ActiveModelSerializers::SerializableResource.new(items, each_serializer: CartItemSerializer))
      end

      def create
        product = Product.find(cart_item_params[:product_id])
        item = current_user.cart_items.find_or_initialize_by(product:)
        item.quantity = item.quantity.to_i + cart_item_params[:quantity].to_i
        if item.save
          render_success(data: CartItemSerializer.new(item).serializable_hash, message: 'Item added to cart', status: :created)
        else
          render_error(errors: item.errors.full_messages)
        end
      end

      def update
        item = current_user.cart_items.find(params[:id])
        if item.update(cart_item_params)
          render_success(data: CartItemSerializer.new(item).serializable_hash, message: 'Cart updated')
        else
          render_error(errors: item.errors.full_messages)
        end
      end

      def destroy
        item = current_user.cart_items.find(params[:id])
        item.destroy
        render_success(data: {}, message: 'Item removed')
      end

      private

      def cart_item_params
        params.require(:cart_item).permit(:product_id, :quantity)
      end
    end
  end
end
