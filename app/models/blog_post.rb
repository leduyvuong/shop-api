# frozen_string_literal: true

class BlogPost < ApplicationRecord
  validates :title, :slug, :content, presence: true
  validates :slug, uniqueness: true

  scope :published, -> { where(published: true) }
end
