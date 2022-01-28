module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.create(user_params)
        if user.save
          render json: user, status: :created
        else
          p user
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password, :first_name, :last_name)
      end
    end
  end
end
