# frozen_string_literal: true

class ProductImage < ApplicationRecord
  belongs_to :product

  has_one_attached :image

  validates :image_url, presence: true, unless: -> { image.attached? }
end
