# frozen_string_literal: true

class CouponSerializer < ActiveModel::Serializer
  attributes :id, :code, :discount_type, :discount_value, :usage_limit, :used_count, :expired_at
end
