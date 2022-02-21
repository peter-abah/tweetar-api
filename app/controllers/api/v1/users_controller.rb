module Api
  module V1
    class UsersController < ApplicationController
      include Paginate
      include Filterable

      before_action :authenticate_request!, only: %i[update destroy]

      def index
        users = filter(User.all.includes(
          profile_image_attachment: :blob,
          cover_image_attachment: :blob
        ))
        @users = paginate(users)
      end

      def followers
        users = filter(user.followers)
        @users = paginate(users)
        render 'api/v1/users/index'
      end

      def followed_users
        users = filter(user.followed_users)
        @users = paginate(users)
        render 'api/v1/users/index'
      end

      def create
        @user = User.create(user_params)

        if @user.save
          render 'api/v1/users/auth', status: :created
        else
          render json: { error: ErrorsBuilder.new(@user).errors }, status: :unprocessable_entity
        end
      end

      def show
        @user = user
      end

      def update
        if user != @current_user
          render json: { error: 'Forbidden can only edit your own profile' }, status: :forbidden
          return
        end

        if @current_user.update(user_params)
          @user = @current_user
          render 'api/v1/users/show'
        else
          render json: { error: ErrorsBuilder.new(@current_user).errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if user != @current_user
          render json: { error: 'forbidden' }, status: :forbidden
          return
        end

        @current_user.destroy

        # rendering empty json instead of no content because jbuilder has a bug with rendering no content
        render json: {}, status: :no_content
      end

      private

      def user
        User.includes(%i[profile_image_attachment cover_image_attachment]).find_by(username: params[:id]) ||
          User.includes(%i[profile_image_attachment cover_image_attachment]).find(params[:id])
      end

      def user_json(user, options = { methods: [:authentication_token] })
        Representer.new(user, options, { user: @current_user }).as_json
      end

      def user_params
        params.require(:user)
          .permit(:username, :password, :password_confirmation, :first_name, 
                 :last_name, :email, :profile_image, :cover_image)
      end
    end
  end
end
