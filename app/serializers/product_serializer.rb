# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :price, :sale_price, :description, :stock, :status, :weight, :sku, :brand, :effective_price
  belongs_to :category
  has_many :variants
  has_many :product_images
end
