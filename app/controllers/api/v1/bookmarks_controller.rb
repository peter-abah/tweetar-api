module Api
  module V1
    class BookmarksController < ApplicationController
      include Paginate
      include Filterable

      before_action :authenticate_request!

      def index
        bookmarks = @current_user.bookmarks.all.includes(**bookmark_includes_options)
        @tweet_actions = paginate(bookmarks)
        render 'api/v1/tweet_actions/index'
      end

      def create
        tweet_id = params[:bookmark][:tweet_id]
        if @current_user.bookmarks.exists?(tweet_id: tweet_id)
          render json: { error: 'You already bookmarked this tweet' }, status: :unprocessable_entity
          return
        end

        @tweet_action = @current_user.bookmarks.build(bookmark_params)

        if @tweet_action.save
          render 'api/v1/tweet_actions/show', status: :created
        else
          errors = ErrorsBuilder.new(@tweet).errors
          render json: { error: errors }, status: :unprocessable_entity
        end
      end

      def show
        @tweet_action = bookmark
        render 'api/v1/tweet_actions/show'
      end


      def destroy
        bookmark = @current_user.bookmarks.find(params[:id])
        bookmark.destroy

        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      private

      def bookmark
        Bookmark.includes(bookmark_includes_options).find(params[:id])
      end

      def bookmark_includes_options
        {
          user: {
            profile_image_attachment: :blob,
            cover_image_attachment: :blob
          },
          tweet: {
            images_attachments: :blob
          }
        }
      end

      def bookmark_params
        params.require(:bookmark).permit(:tweet_id)
      end
    end
  end
end
