# frozen_string_literal: true

module Api
  module V1
    class OrdersController < Api::V1::BaseController
      before_action :set_order, only: %i[show update destroy cancel complete ship]

      def index
        orders = policy_scope(Order).includes(:order_items, :payment)
        render_success(data: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer))
      end

      def show
        authorize @order
        render_success(data: OrderSerializer.new(@order).serializable_hash)
      end

      def create
        authorize Order
        service = CheckoutService.new(user: current_user, params: checkout_params)
        result = service.call
        if result.success?
          render_success(data: OrderSerializer.new(result.order).serializable_hash, message: 'Order created', status: :created)
        else
          render_error(errors: result.errors)
        end
      end

      def update
        authorize @order
        if @order.update(order_params)
          render_success(data: OrderSerializer.new(@order).serializable_hash, message: 'Order updated')
        else
          render_error(errors: @order.errors.full_messages)
        end
      end

      def destroy
        authorize @order
        @order.destroy
        render_success(data: {}, message: 'Order deleted')
      end

      def cancel
        authorize @order, :cancel?
        @order.update!(status: :canceled)
        NotificationMailer.with(order: @order).order_canceled.deliver_later
        render_success(data: OrderSerializer.new(@order).serializable_hash, message: 'Order canceled')
      end

      def complete
        authorize @order, :complete?
        @order.update!(status: :completed)
        render_success(data: OrderSerializer.new(@order).serializable_hash, message: 'Order completed')
      end

      def ship
        authorize @order, :ship?
        @order.update!(status: :shipped)
        render_success(data: OrderSerializer.new(@order).serializable_hash, message: 'Order shipped')
      end

      private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:status, :payment_method, :shipping_fee)
      end

      def checkout_params
        params.require(:checkout).permit(:address_id, :coupon_code, :payment_method)
      end
    end
  end
end
