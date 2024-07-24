class UserForm
  include ActiveModel::Model
  include ActiveRecord::Validations

  attr_accessor :first_name, :last_name, :email, :user, :id, :created_at, :updated_at

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, uniqueness: true

  def errors
    @user.errors
  end

  def initialize(user_or_params = {})
    @user = user_or_params.is_a?(User) ? user_or_params : User.new(user_or_params)
  end

  def save
    return false unless @user.valid?

    @user.save
  end

  def update(params)
    @user.attributes = params
    return false unless @user.valid?

    @user.update(params)
  end
end
