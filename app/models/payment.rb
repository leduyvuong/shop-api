# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order

  enum status: { pending: 0, succeeded: 1, failed: 2 }, _default: :pending

  validates :amount, numericality: { greater_than: 0 }
  validates :method, presence: true
end
