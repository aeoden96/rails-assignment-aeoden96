module Api
  class UsersController < ApplicationController
    def index
      render json: render_index_serializer(UserSerializer, User.all, :users)
    end

    def show
      user = User.find(params[:id])

      if user
        render json: render_serializer_show(UserSerializer, JsonapiSerializer::UserSerializer,
                                            user, :user)
      else
        render json: { errors: 'User not found' }, status: :not_found
      end
    end

    def create
      form = UserForm.new(user_params)
      if form.save
        render json: UserSerializer.render(form.user, root: :user), status: :created
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    def update
      user = User.find(params[:id])
      form = UserForm.new(user)

      if form.update(user_params)
        render json: UserSerializer.render(@form.user, root: :user)
      else
        render json: { errors: @form.errors }, status: :bad_request
      end
    end

    def destroy
      user = User.find(params[:id])

      user.destroy
      render json: { message: 'User deleted' }, status: :no_content
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
end
