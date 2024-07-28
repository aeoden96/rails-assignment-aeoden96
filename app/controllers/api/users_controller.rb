module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create, :index]
    before_action :authenticate_admin!, only: [:index]
    before_action :authorize_action!, only: [:update, :destroy, :show]

    def index
      render json: render_index_serializer(UserSerializer, User.all, :users)
    end

    def show
      # handle the case where the user is admin
      if !current_user.admin?
        render json: render_serializer_show(UserSerializer, JsonapiSerializer::UserSerializer,
                                            @current_user, :user)
      else
        user = User.find(params[:id])
        render json: render_serializer_show(UserSerializer, JsonapiSerializer::UserSerializer,
                                            user, :user)
      end
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      user = User.find(params[:id])

      if user.update(user_params)
        render json: UserSerializer.render(user, root: :user)
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy

      head :no_content
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :role)
    end

    def authorize_action!
      return unless @current_user.id != params[:id].to_i && !@current_user.admin?

      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
