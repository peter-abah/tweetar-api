module Api
  module V1
    class LikesController < ApplicationController
      before_action :authenticate_request!, only: %i[create destroy]
      include Paginate

      def index
        likes = params[:user_id] ? User.find(params[:user_id]).likes : Tweet.find(params[:tweet_id]).likes
        @tweet_actions = paginate(likes)
        render 'api/v1/tweet_actions/index'
      end

      def show
        @tweet_action = Like.find(params[:id])
        render 'api/v1/tweet_actions/show'
      end

      def create
        if valid_like?
          return render json: { error: 'You already liked this tweet' }, status: :unprocessable_entity
        end

        @tweet_action = @current_user.likes.build(tweet_id: params[:tweet_id])

        if @tweet_action.save
          render 'api/v1/tweet_actions/show'
        else
          render json: { error: like.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        like = @current_user.likes.find_by!(tweet_id: params[:tweet_id])
        like.destroy

        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      def valid_like?
        @current_user.likes.exists?(tweet_id: params[:tweet_id])
      end
    end
  end
end
