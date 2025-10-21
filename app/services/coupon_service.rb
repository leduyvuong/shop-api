# frozen_string_literal: true

class CouponService
  def initialize(code:, user:)
    @code = code
    @user = user
  end

  def call
    coupon = Coupon.find_by(code: code)
    return failure('Coupon not found') unless coupon
    return failure('Coupon expired') if coupon.expired?
    return failure('Coupon usage limit reached') unless coupon.available?

    discount_amount = compute_discount(coupon)
    coupon.increment!(:used_count)

    ServiceResult.new(success: true, payload: { coupon:, discount_amount: })
  rescue StandardError => e
    failure(e.message)
  end

  private

  attr_reader :code, :user

  def compute_discount(coupon)
    cart_total = user.cart_items.sum { |item| item.subtotal }
    case coupon.discount_type
    when 'percentage'
      (cart_total * coupon.discount_value / 100.0).round(2)
    else
      coupon.discount_value
    end
  end

  def failure(message)
    ServiceResult.new(success: false, errors: message)
  end
end
