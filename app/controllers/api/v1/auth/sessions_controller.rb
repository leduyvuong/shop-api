# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < Api::V1::BaseController
        skip_before_action :authenticate_user!, only: :create

        def create
          user = User.find_for_database_authentication(email: params[:email])
          if user&.valid_password?(params[:password])
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            render_success(data: { user: UserSerializer.new(user).serializable_hash, token: }, message: 'Signed in successfully')
          else
            render_error(errors: ['Invalid email or password'], status: :unauthorized)
          end
        end

        def destroy
          render_success(data: {}, message: 'Signed out')
        end
      end
    end
  end
end