# frozen_string_literal: true

module Api
  module V1
    module Auth
      class PasswordsController < Api::V1::BaseController
        skip_before_action :authenticate_user!, only: %i[create update]

        def create
          user = User.find_by(email: params[:email])
          if user
            token = user.send_reset_password_instructions
            render_success(data: { reset_token: token }, message: 'Reset instructions sent')
          else
            render_error(errors: ['Email not found'], status: :not_found)
          end
        end

        def update
          user = User.reset_password_by_token(reset_password_params)
          if user.errors.empty?
            render_success(data: {}, message: 'Password updated')
          else
            render_error(errors: user.errors.full_messages)
          end
        end

        private

        def reset_password_params
          params.permit(:reset_password_token, :password, :password_confirmation)
        end
      end
    end
  end
end
