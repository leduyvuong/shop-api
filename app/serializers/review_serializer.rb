# frozen_string_literal: true

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_id, :rating, :comment, :created_at
  belongs_to :user
end
