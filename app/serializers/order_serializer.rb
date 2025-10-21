# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :status, :total_price, :payment_method, :shipping_fee, :created_at
  belongs_to :address
  has_many :order_items
  has_one :payment
end
