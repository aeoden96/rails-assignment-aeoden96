class AddPasswordDigestToUsers < ActiveRecord::Migration[6.1]
  #def change
  #  add_column :users, :password_digest, :string
  #end

  def change_password_on_existing_users
    User.reset_column_information
    User.find_each do |user|
      user.update(password: SecureRandom.hex(8)) if user.password_digest.blank?
    end
  end

  def up
    add_column :users, :password_digest, :string
    change_password_on_existing_users
    change_column :users, :password_digest, :string, null: false
  end

  def down
    remove_column :users, :password_digest
  end
end
