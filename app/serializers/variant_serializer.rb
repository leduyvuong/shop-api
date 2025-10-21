# frozen_string_literal: true

class VariantSerializer < ActiveModel::Serializer
  attributes :id, :option_name, :option_value, :price, :stock
end
