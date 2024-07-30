module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    before_action :authenticate_admin!, only: [:index]
    before_action :authorize_action!, only: [:update, :destroy, :show]

    def index
      users = UsersQuery.new(params).call
      render json: render_index_serializer(UserSerializer, users, :users)
    end

    def show
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
      token = request.headers['Authorization']
      current_user = User.find_by(token: token)

      user = User.new(!current_user ||
      !current_user.admin? ? user_params.except(:role) : user_params)

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      user = User.find(params[:id])

      if !current_user.admin? && user_params[:role]
        render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
        return
      end

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
      params.require(:user).permit(:first_name, :last_name, :email, :password, :role, :token)
    end

    def authorize_action!
      return unless @current_user.id != params[:id].to_i && !@current_user.admin?

      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
