module Api
  module V1
    class RetweetsController < ApplicationController
      include Paginate

      before_action :authenticate_request!, only: %i[create destroy]

      def index
        retweets = if params[:user_id] 
                     User.find(params[:user_id]).retweets
                   else
                     Tweet.find(params[:tweet_id]).retweets
                   end

        retweets = paginate(retweets)

        render json: Representer.new(retweets, {}, { user: @current_user }).as_json, status: :ok
      end

      def show
        retweet = Retweet.find(params[:id])
        render json: Representer.new(retweet, {}, { user: @current_user }).as_json, status: :ok
      end

      def create
        retweet = @current_user.retweets.build(tweet_id: params[:tweet_id])

        if retweet.save
          render json: Representer.new(retweet, {}, { user: @current_user }).as_json, status: :ok
        else
          render json: { error: retweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        retweet = @current_user.retweets.find(params[:id])
        retweet.destroy
        render status: :no_content
      end
    end
  end
end
