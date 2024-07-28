# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string           not null
#  last_name       :string
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  token           :string
#  role            :string
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :password, presence: true, on: :create
  validates :token, uniqueness: true
  validate :password_not_blank, on: :update
  validates :role, inclusion: { in: %w[admin] }, allow_nil: true

  # Instance method to login user and generate a new token
  def login
    regenerate_token
    token
  end

  # Instance method to logout user by invalidating the token
  def logout
    update(token: nil)
  end

  private

  def password_not_blank
    return unless password_digest_changed? && (password.nil? || password.blank?)

    errors.add(:password, "can't be blank")
  end
end
