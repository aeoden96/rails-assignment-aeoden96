class UsersQuery
  def initialize(params = {})
    @params = params
  end

  def call
    users = User.all
    users = users.order(:email)
    if @params[:query].present?
      query = params[:query].downcase
      users = users.where(
        'LOWER(email) LIKE ? OR LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?',
        "%#{query}%", "%#{query}%", "%#{query}%"
      )
    end
    users
  end
end
