# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < Api::V1::BaseController
      before_action :set_order, only: %i[index create]
      before_action :set_payment, only: :show

      def index
        authorize(@order || Payment)
        payments = if @order
                     Array(@order.payment).compact
                   else
                     policy_scope(Payment)
                   end
        render_success(data: ActiveModelSerializers::SerializableResource.new(payments, each_serializer: PaymentSerializer))
      end

      def show
        authorize @payment
        render_success(data: PaymentSerializer.new(@payment).serializable_hash)
      end

      def create
        authorize @order, :update?
        service = PaymentService.new(order: @order, payment_params: payment_params)
        result = service.call
        if result.success?
          render_success(data: PaymentSerializer.new(result.payment).serializable_hash, message: 'Payment created', status: :created)
        else
          render_error(errors: result.errors)
        end
      end

      private

      def set_order
        @order = Order.find(params[:order_id]) if params[:order_id]
      end

      def set_payment
        @payment = Payment.find(params[:id])
      end

      def payment_params
        params.require(:payment).permit(:amount, :method, :transaction_id)
      end
    end
  end
end
