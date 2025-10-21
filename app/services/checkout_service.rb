# frozen_string_literal: true

class CheckoutService
  SHIPPING_FEE = 2.5

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      address = user.addresses.find(params[:address_id])
      items = user.cart_items.includes(:product)
      return failure('Cart is empty') if items.blank?

      coupon_result = CouponService.new(code: params[:coupon_code], user:).call if params[:coupon_code].present?
      return coupon_result if coupon_result.failure?

      order = user.orders.create!(
        address:,
        status: :pending,
        payment_method: params[:payment_method],
        shipping_fee: SHIPPING_FEE,
        total_price: calculate_total(items, coupon_result)
      )

      items.each do |item|
        order.order_items.create!(product: item.product, quantity: item.quantity, price: item.product.effective_price)
        item.product.decrement!(:stock, item.quantity)
      end

      user.cart_items.delete_all
      NotificationMailer.with(order:).order_created.deliver_later

      ServiceResult.new(success: true, payload: { order: })
    end
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  rescue StandardError => e
    failure(e.message)
  end

  private

  attr_reader :user, :params

  def calculate_total(items, coupon_result)
    subtotal = items.sum { |item| item.subtotal }
    discount = coupon_result&.payload.to_h.fetch(:discount_amount, 0)
    subtotal + SHIPPING_FEE - discount
  end

  def failure(errors)
    ServiceResult.new(success: false, errors:)
  end
end
