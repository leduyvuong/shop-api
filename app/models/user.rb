# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum :role, { customer: 0, admin: 1, staff: 2 }, default: :customer

  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true
  validates :phone, allow_blank: true, format: { with: /\A[0-9+\-]{8,15}\z/ }
end
