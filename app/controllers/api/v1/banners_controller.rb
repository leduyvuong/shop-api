# frozen_string_literal: true

module Api
  module V1
    class BannersController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_banner, only: %i[show update destroy]

      def index
        banners = policy_scope(Banner).where(active: true)
        render_success(data: ActiveModelSerializers::SerializableResource.new(banners, each_serializer: BannerSerializer))
      end

      def show
        authorize @banner
        render_success(data: BannerSerializer.new(@banner).serializable_hash)
      end

      def create
        banner = Banner.new(banner_params)
        authorize banner
        if banner.save
          render_success(data: BannerSerializer.new(banner).serializable_hash, message: 'Banner created', status: :created)
        else
          render_error(errors: banner.errors.full_messages)
        end
      end

      def update
        authorize @banner
        if @banner.update(banner_params)
          render_success(data: BannerSerializer.new(@banner).serializable_hash, message: 'Banner updated')
        else
          render_error(errors: @banner.errors.full_messages)
        end
      end

      def destroy
        authorize @banner
        @banner.destroy
        render_success(data: {}, message: 'Banner deleted')
      end

      private

      def set_banner
        @banner = Banner.find(params[:id])
      end

      def banner_params
        params.require(:banner).permit(:title, :image_url, :link_url, :active)
      end
    end
  end
end
