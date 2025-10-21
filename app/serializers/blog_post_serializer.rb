# frozen_string_literal: true

class BlogPostSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :content, :published, :created_at
end
