module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!, only: %i[update destroy]

      def index
        users = User.all
        render json: users, status: :ok
      end

      def create
        user = User.create(user_params)
        if user.save
          render json: user.as_json({}, add_token: true), status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def show
        render json: user, status: :ok
      end

      def update
        if user != @current_user
          render json: { error: 'forbidden' }, status: :forbidden
          return
        end

        if @current_user.update(user_params)
          render json: user.as_json({}, add_token: true), status: :ok
        else
          pp @current_user.errors.full_messages, user_params
          render json: { error: @current_user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def destroy
        if user != @current_user
          render json: { error: 'forbidden' }, status: :forbidden
          return
        end

        @current_user.destroy
        render status: :no_content
      end

      private

      def user
        User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :first_name, :last_name, :email)
      end
    end
  end
end
