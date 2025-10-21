# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, numericality: { greater_than: 0 }

  def subtotal
    price * quantity
  end
end
