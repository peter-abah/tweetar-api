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
        unless valid_bookmark?
          return render json: { error: 'You already bookmarked this tweet' }, status: :unprocessable_entity
        end

        @tweet_action = @current_user.bookmarks.build(tweet_id: params[:tweet_id])

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
        bookmark = @current_user.bookmarks.find_by!(tweet_id: params[:tweet_id])
        bookmark.destroy

        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      private

      def valid_bookmark?
        !@current_user.bookmarks.exists?(tweet_id: params[:tweet_id])
      end

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
    end
  end
end
