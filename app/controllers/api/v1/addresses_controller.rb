# frozen_string_literal: true

module Api
  module V1
    class AddressesController < Api::V1::BaseController
      before_action :set_address, only: %i[show update destroy set_default]

      def index
        authorize Address
        addresses = policy_scope(Address).order(default: :desc, created_at: :desc)
        render_success(data: ActiveModelSerializers::SerializableResource.new(addresses, each_serializer: AddressSerializer))
      end

      def show
        authorize @address
        render_success(data: AddressSerializer.new(@address).serializable_hash)
      end

      def create
        address = Address.new(address_params)
        address.user ||= current_user
        authorize address

        if persist_with_default(address)
          render_success(data: AddressSerializer.new(address).serializable_hash, message: 'Address created', status: :created)
        else
          render_error(errors: address.errors.full_messages)
        end
      end

      def update
        authorize @address
        @address.assign_attributes(address_params)

        if persist_with_default(@address)
          render_success(data: AddressSerializer.new(@address).serializable_hash, message: 'Address updated')
        else
          render_error(errors: @address.errors.full_messages)
        end
      end

      def destroy
        authorize @address
        @address.destroy
        render_success(data: {}, message: 'Address removed')
      end

      def set_default
        authorize @address, :update?

        Address.transaction do
          ensure_single_default(@address)
          @address.update!(default: true)
        end

        render_success(data: AddressSerializer.new(@address.reload).serializable_hash, message: 'Default address updated')
      rescue ActiveRecord::RecordInvalid => e
        render_error(errors: @address.errors.full_messages.presence || [e.message])
      end

      private

      def set_address
        @address = Address.find(params[:id])
      end

      def address_params
        permitted = %i[name phone province district ward street default]
        permitted << :user_id if current_user&.admin? && action_name == 'create'
        params.require(:address).permit(permitted)
      end

      def persist_with_default(address)
        Address.transaction do
          ensure_single_default(address) if default_selected?(address)
          address.save!
        end
        true
      rescue ActiveRecord::RecordInvalid
        false
      end

      def ensure_single_default(address)
        Address.where(user_id: address.user_id).where.not(id: address.id).update_all(default: false)
      end

      def default_selected?(address)
        ActiveModel::Type::Boolean.new.cast(address.default)
      end
    end
  end
end
