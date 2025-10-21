# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  scope :roots, -> { where(parent_id: nil) }
end
