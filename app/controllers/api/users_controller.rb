module Api
  class UsersController < ApplicationController
    def index
      render json: UserSerializer.render(User.all, view: :include_associations)
    end

    def show
      user = User.find(params[:id])

      if user
        render json: UserSerializer.render(user)
      else
        render json: { errors: 'User not found' }, status: :not_found
      end
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: UserSerializer.render(user), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
end