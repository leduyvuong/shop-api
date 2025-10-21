# frozen_string_literal: true

module Api
  module V1
    class BlogPostsController < Api::V1::BaseController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_blog_post, only: %i[show update destroy]

      def index
        posts = policy_scope(BlogPost).page(params[:page])
        render_success(data: ActiveModelSerializers::SerializableResource.new(posts, each_serializer: BlogPostSerializer))
      end

      def show
        authorize @blog_post
        render_success(data: BlogPostSerializer.new(@blog_post).serializable_hash)
      end

      def create
        post = BlogPost.new(blog_post_params)
        authorize post
        if post.save
          render_success(data: BlogPostSerializer.new(post).serializable_hash, message: 'Blog post created', status: :created)
        else
          render_error(errors: post.errors.full_messages)
        end
      end

      def update
        authorize @blog_post
        if @blog_post.update(blog_post_params)
          render_success(data: BlogPostSerializer.new(@blog_post).serializable_hash, message: 'Blog post updated')
        else
          render_error(errors: @blog_post.errors.full_messages)
        end
      end

      def destroy
        authorize @blog_post
        @blog_post.destroy
        render_success(data: {}, message: 'Blog post deleted')
      end

      private

      def set_blog_post
        @blog_post = BlogPost.find(params[:id])
      end

      def blog_post_params
        params.require(:blog_post).permit(:title, :slug, :content, :published)
      end
    end
  end
end
