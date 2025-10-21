# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :set_user, only: %i[show update destroy]

      def index
        authorize User
        users = policy_scope(User).page(params[:page])
        render_success(data: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UserSerializer))
      end

      def show
        authorize @user
        render_success(data: UserSerializer.new(@user).serializable_hash)
      end

      def create
        user = User.new(user_params)
        authorize user
        if user.save
          render_success(data: UserSerializer.new(user).serializable_hash, message: 'User created', status: :created)
        else
          render_error(errors: user.errors.full_messages)
        end
      end

      def update
        authorize @user
        if @user.update(user_params)
          render_success(data: UserSerializer.new(@user).serializable_hash, message: 'User updated')
        else
          render_error(errors: @user.errors.full_messages)
        end
      end

      def destroy
        authorize @user
        @user.destroy
        render_success(data: {}, message: 'User deleted')
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone)
      end
    end
  end
end
