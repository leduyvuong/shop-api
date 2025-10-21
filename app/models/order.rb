# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy

  enum :status, { pending: 0, paid: 1, shipped: 2, completed: 3, canceled: 4 }, default: :pending

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def subtotal
    order_items.sum('quantity * price')
  end
end
