# frozen_string_literal: true

class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :quantity, :price, :subtotal
  belongs_to :product
end
