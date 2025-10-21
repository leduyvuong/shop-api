# frozen_string_literal: true

class Variant < ApplicationRecord
  belongs_to :product

  validates :option_name, :option_value, :price, presence: true

  def display_name
    "#{option_name}: #{option_value}"
  end
end
