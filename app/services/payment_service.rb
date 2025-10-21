# frozen_string_literal: true

class PaymentService
  def initialize(order:, payment_params:)
    @order = order
    @payment_params = payment_params
  end

  def call
    ActiveRecord::Base.transaction do
      payment = order.build_payment(payment_params.merge(status: :succeeded))
      payment.save!
      order.update!(status: :paid, total_price: order.subtotal + order.shipping_fee)
      ServiceResult.new(success: true, payload: { payment:, order: })
    end
  rescue ActiveRecord::RecordInvalid => e
    ServiceResult.new(success: false, errors: e.record.errors.full_messages)
  rescue StandardError => e
    ServiceResult.new(success: false, errors: e.message)
  end

  private

  attr_reader :order, :payment_params
end
