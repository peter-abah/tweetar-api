module Api
  module V1
    class FollowsController < ApplicationController
      before_action :authenticate_request!

      def create
        if user == @current_user
          render json: { error: 'You cannot follow yourself' }, status: :forbidden
          return
        end

        if @current_user.followed_users.include?(user)
          render json: { error: 'Already following' }, status: :forbidden
          return
        end

        follow = Follow.new(follower_id: @current_user.id, followed_id: user.id)

        @user = follow.followed
        if follow.save
          render 'api/v1/users/show'
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

        @user = follow.followed
        follow.destroy
        render 'api/v1/users/show'
      end

      private

      def user
        User.find(params[:id])
      end
    end
  end
end
