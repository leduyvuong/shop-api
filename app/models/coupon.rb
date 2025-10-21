# frozen_string_literal: true

class Coupon < ApplicationRecord
  enum discount_type: { percentage: 0, amount: 1 }, _default: :percentage

  validates :code, :discount_type, :discount_value, presence: true
  validates :code, uniqueness: true
  validates :discount_value, numericality: { greater_than: 0 }
  validate :not_expired

  def available?
    (usage_limit.nil? || used_count < usage_limit) && !expired?
  end

  def expired?
    expired_at.present? && expired_at < Time.current
  end

  private

  def not_expired
    return if expired_at.blank? || expired_at.future?

    errors.add(:expired_at, 'must be in the future')
  end
end
