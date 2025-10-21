# frozen_string_literal: true

module Api
  module V1
    class CouponsController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_coupon, only: %i[show update destroy]

      def index
        authorize Coupon
        coupons = policy_scope(Coupon).page(params[:page])
        render_success(data: ActiveModelSerializers::SerializableResource.new(coupons, each_serializer: CouponSerializer))
      end

      def show
        authorize @coupon
        render_success(data: CouponSerializer.new(@coupon).serializable_hash)
      end

      def create
        coupon = Coupon.new(coupon_params)
        authorize coupon
        if coupon.save
          render_success(data: CouponSerializer.new(coupon).serializable_hash, message: 'Coupon created', status: :created)
        else
          render_error(errors: coupon.errors.full_messages)
        end
      end

      def update
        authorize @coupon
        if @coupon.update(coupon_params)
          render_success(data: CouponSerializer.new(@coupon).serializable_hash, message: 'Coupon updated')
        else
          render_error(errors: @coupon.errors.full_messages)
        end
      end

      def destroy
        authorize @coupon
        @coupon.destroy
        render_success(data: {}, message: 'Coupon deleted')
      end

      def apply
        authorize Coupon, :apply?
        result = CouponService.new(code: params[:code], user: current_user).call
        if result.success?
          coupon = result.payload[:coupon]
          render_success(
            data: {
              coupon: CouponSerializer.new(coupon).serializable_hash,
              discount_amount: result.payload[:discount_amount]
            },
            message: 'Coupon applied'
          )
        else
          render_error(errors: result.errors, status: :unprocessable_entity)
        end
      end

      private

      def set_coupon
        @coupon = Coupon.find(params[:id])
      end

      def coupon_params
        params.require(:coupon).permit(:code, :discount_type, :discount_value, :usage_limit, :expired_at)
      end
    end
  end
end
