module Api
  module V1
    class FollowsController < ApplicationController
      before_action :authenticate_request!

      def create
        if user == @current_user
          render json: { error: 'You can not follow yourself' }, status: :forbidden
          return
        end

        if @current_user.followed_users.include?(user)
          render json: { error: 'Already following' }, status: :forbidden
          return
        end

        follow = Follow.new(follower_id: @current_user.id, followed_id: user.id)

        if follow.save
          render status: :no_content
        else
          render json: { error: follow.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        follow = Follow.find_by follower_id: @current_user.id, followed_id: user.id

        unless follow
          render json: { error: 'Not following' }, status: :not_found unless follow
          return
        end

        follow.destroy
        render status: :no_content
      end

      private

      def user
        User.find(params[:user_id])
      end
    end
  end
end
