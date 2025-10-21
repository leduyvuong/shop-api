# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RegistrationsController < Api::V1::BaseController
        skip_before_action :authenticate_user!, only: :create

        def create
          user = User.new(user_params)
          if user.save
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            render_success(data: { user: UserSerializer.new(user).serializable_hash, token: }, message: 'Signed up successfully', status: :created)
          else
            render_error(errors: user.errors.full_messages)
          end
        end

        private

        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone)
        end
      end
    end
  end
end
