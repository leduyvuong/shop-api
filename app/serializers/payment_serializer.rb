# frozen_string_literal: true

class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :amount, :method, :status, :transaction_id, :created_at
end
