module Api
  module V1
    class TweetsController < ApplicationController
      include Paginate
      include Filterable

      before_action :authenticate_request!, only: %i[create update destroy]

      def index
        filtered_tweets = filter(Tweet.all.includes(
          **tweet_includes_options,
          parent: { **tweet_includes_options }
        ))
        @tweets = paginate(filtered_tweets)
      end

      def create
        @tweet = @current_user.tweets.build(tweet_params)

        if @tweet.save
          render 'api/v1/tweets/show', status: :created
        else
          errors = ErrorsBuilder.new(@tweet).errors
          render json: { error: errors }, status: :unprocessable_entity
        end
      end

      def show
        @tweet = tweet
      end

      def update
        @tweet = @current_user.tweets.find(params[:id])

        if @tweet.update(tweet_params)
          render 'api/v1/tweets/show'
        else
          errors = ErrorsBuilder.new(@tweet).errors
          render json: { error: errors }, status: :unprocessable_entity
        end
      end

      def destroy
        tweet = @current_user.tweets.find(params[:id])
        tweet.destroy

        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      def replies
        tweet = Tweet.find(params[:tweet_id])
        @tweets = paginate(tweet.replies)
        render 'api/v1/tweets/index'
      end

      private

      def tweet
        Tweet.includes(images_attachments: :blob).find(params[:id])
      end

      def tweet_includes_options
        {
          user: {
            profile_image_attachment: :blob,
            cover_image_attachment: :blob
          },
          images_attachments: :blob
        }
      end

      def tweet_params
        params.require(:tweet).permit(:body, :parent_id, images: [])
      end
    end
  end
end
