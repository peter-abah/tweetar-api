module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.all
        render json: users, status: :ok
      end

      def create
        user = User.create(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def show
        render json: user, status: :ok
      end

      private

      def user
        User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :password, :first_name, :last_name, :email)
      end
    end
  end
end
