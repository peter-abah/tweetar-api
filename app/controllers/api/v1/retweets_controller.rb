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

        @tweet_actions = paginate(retweets)
        render 'api/v1/tweet_actions/index'
      end

      def show
        @tweet_action = Retweet.find(params[:id])
        render 'api/v1/tweet_actions/show'
      end

      def create
        if valid_retweet?
          return render json: { error: 'You already retweeted this tweet' }, status: :unprocessable_entity
        end

        @tweet_action = @current_user.retweets.build(tweet_id: params[:tweet_id])

        if @tweet_action.save
          render 'api/v1/tweet_actions/show'
        else
          render json: { error: retweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        retweet = @current_user.retweets.find_by!(tweet_id: params[:tweet_id])
        retweet.destroy
        
        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      private

      def valid_retweet?
        @current_user.retweets.exists?(tweet_id: params[:tweet_id])
      end
    end
  end
end
