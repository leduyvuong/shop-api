# frozen_string_literal: true

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :province, :district, :ward, :street, :default
end
