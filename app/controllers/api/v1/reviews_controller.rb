# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_review, only: %i[show update destroy]

      def index
        reviews = policy_scope(Review).where(product_id: params[:product_id]).page(params[:page])
        render_success(data: ActiveModelSerializers::SerializableResource.new(reviews, each_serializer: ReviewSerializer))
      end

      def show
        authorize @review
        render_success(data: ReviewSerializer.new(@review).serializable_hash)
      end

      def create
        review = current_user.reviews.new(review_params)
        authorize review
        if review.save
          render_success(data: ReviewSerializer.new(review).serializable_hash, message: 'Review created', status: :created)
        else
          render_error(errors: review.errors.full_messages)
        end
      end

      def update
        authorize @review
        if @review.update(review_params)
          render_success(data: ReviewSerializer.new(@review).serializable_hash, message: 'Review updated')
        else
          render_error(errors: @review.errors.full_messages)
        end
      end

      def destroy
        authorize @review
        @review.destroy
        render_success(data: {}, message: 'Review deleted')
      end

      private

      def set_review
        @review = Review.find(params[:id])
      end

      def review_params
        params.require(:review).permit(:product_id, :rating, :comment)
      end
    end
  end
end
