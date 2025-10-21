# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :parent_id
  has_many :children, serializer: CategorySerializer
end
