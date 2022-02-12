module Api
  module V1
    class LikesController < ApplicationController
      before_action :authenticate_request!, only: %i[create destroy]
      include Paginate

      def index
        likes = params[:user_id] ? User.find(params[:user_id]).likes : Tweet.find(params[:tweet_id]).likes
        likes = paginate(likes)

        render json: Representer.new(likes).as_json, status: :ok
      end

      def show
        like = Like.find(params[:id])
        render json: Representer.new(like).as_json, status: :ok
      end

      def create
        like = @current_user.likes.build(tweet_id: params[:tweet_id])

        if like.save
          render json: Representer.new(like).as_json, status: :ok
        else
          render json: { error: like.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        like = @current_user.likes.find(params[:id])
        like.destroy
        render status: :no_content
      end
    end
  end
end
