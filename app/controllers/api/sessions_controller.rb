module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: session_params[:email])

      if user&.authenticate(session_params[:password])
        render json: SessionSerializer.render({ user: user, token: user.login })
      else
        render json: { error: { credentials: ['are invalid'] } }, status: :unauthorized
      end
    end

    def destroy
      user = User.find_by(token: request.headers['Authorization'])
      if user
        user.logout
        render json: { message: 'Logged out successfully' }
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
