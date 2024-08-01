class UsersQuery
  def initialize(params = {})
    @params = params
  end

  def with_filters
    users = User.all
    users = users.order(:email)
    if @params[:query].present?
      query = @params[:query].downcase
      users = users.where(
        'LOWER(email) LIKE :query OR LOWER(first_name) LIKE :query OR LOWER(last_name) LIKE :query',
        query: "%#{query}%"
      )
    end
    users
  end
end
