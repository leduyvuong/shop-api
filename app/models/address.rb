# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :name, :phone, :province, :district, :ward, :street, presence: true

  scope :default, -> { where(default: true) }
end
