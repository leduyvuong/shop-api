# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RefreshController < Api::V1::BaseController
        def create
          token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil).first
          render_success(data: { token: }, message: 'Token refreshed')
        end
      end
    end
  end
end
