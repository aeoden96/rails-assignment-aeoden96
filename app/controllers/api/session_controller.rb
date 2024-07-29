module Api
  class SessionController < ApplicationController
    def create
      user = User.find_by(email: session_params[:email])

      if user&.authenticate(session_params[:password])
        render json: SessionSerializer.render({ user: user, token: user.login }, root: :session),
               status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
      end
    end

    def destroy
      user = User.find_by(token: request.headers['Authorization'])
      if user
        user.logout
        head :no_content
      else
        render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
      end
    end

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
