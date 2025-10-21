# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :authenticate_user!, only: :options

      def options
        head :ok
      end

      private

      def serializer_for(resource)
        serializer_class = "#{resource.class.name}Serializer".safe_constantize
        serializer_class&.new(resource)
      end
    end
  end
end
