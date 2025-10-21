# frozen_string_literal: true

class BannerSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :link_url, :active
end
