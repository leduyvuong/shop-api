# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy
  has_many :variants, dependent: :destroy
  has_many :order_items
  has_many :reviews, dependent: :destroy

  validates :name, :slug, :price, :stock, presence: true
  validates :slug, uniqueness: true

  enum status: { draft: 0, active: 1, archived: 2 }, _default: :draft

  scope :available, -> { active.where('stock > 0') }
  scope :search, lambda { |query|
    return all if query.blank?

    where('products.name ILIKE :query OR products.sku ILIKE :query', query: "%#{query}%")
  }

  def effective_price
    sale_price.presence || price
  end
end
