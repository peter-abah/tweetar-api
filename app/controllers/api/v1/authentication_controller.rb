module Api
  module V1
    class AuthenticationController < ApplicationController
      class AuthenticationError < StandardError; end

      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from AuthenticationError, with: :handle_unauthenticated

      def create
        if user
          raise AuthenticationError unless user.authenticate(params.require(:password))

          render json: UserRepresenter.new(user, add_token: true).as_json, status: :created
        else
          render json: { error: 'No such user' }, status: :unauthorized
        end
      end

      private

      def user
        @user ||= User.find_by(username: params[:username]) ||
                  User.find_by(email: params[:email])
      end

      def parameter_missing(error)
        render json: { error: error.message }, status: :unprocessable_entity
      end

      def handle_unauthenticated
        render json: { error: 'Incorrect password' }, status: :unauthorized
      end
    end
  end
end
