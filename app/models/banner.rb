# frozen_string_literal: true

class Banner < ApplicationRecord
  validates :title, :image_url, presence: true
end
