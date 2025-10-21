# frozen_string_literal: true

class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :subtotal
  belongs_to :product
end
