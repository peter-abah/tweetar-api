module Api
  module V1
    class RetweetsController < ApplicationController
      include Paginate

      before_action :authenticate_request!, only: %i[create destroy]

      def index
        retweets = params[:user_id] ? User.find(params[:user_id]).retweets : Tweet.find(params[:tweet_id]).retweets
        retweets = paginate(retweets)

        render json: ListRepresenter.new(retweets).as_json, status: :ok
      end

      def show
        retweet = Retweet.find(params[:id])
        render json: DataRepresenter.new(retweet).as_json, status: :ok
      end

      def create
        retweet = @current_user.retweets.build(retweet_params)

        if retweet.save
          render json: DataRepresenter.new(retweet).as_json, status: :ok
        else
          render json: { error: retweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        retweet = @current_user.retweets.find(params[:id])
        retweet.destroy
        render status: :no_content
      end

      private

      def retweet_params
        params.require(:retweet).permit(:tweet_id, :user_id)
      end
    end
  end
end
