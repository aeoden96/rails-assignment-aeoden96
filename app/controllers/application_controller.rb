class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found
    render json: { errors: ['Record not found'] }, status: :not_found
  end

  def render_serializer_show(serializer, alternate_serializer, record, root)
    if request.headers['X-API-SERIALIZER'] == 'jsonapi'
      alternate_serializer.new(record).serializable_hash.to_json
    else
      serializer.render(record, root: root)
    end
  end

  def render_index_serializer(serializer, records, root)
    if request.headers['X-API-SERIALIZER-ROOT'] == '0'
      serializer.render(records)
    else
      serializer.render(records, root: root)
    end
  end

  def authenticate_user!
    token = request.headers['Authorization']
    @current_user = User.find_by(token: token)
    return if @current_user

    render json: { errors: { token: ['is invalid'] } },
           status: :unauthorized
  end

  def authenticate_admin!
    token = request.headers['Authorization']
    @current_user = User.find_by(token: token)
    return if @current_user&.admin?

    render json: { errors: { token: ['is invalid'] } },
           status: :unauthorized
  end

  attr_reader :current_user
end
