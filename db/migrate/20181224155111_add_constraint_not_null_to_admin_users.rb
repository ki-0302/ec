class AddConstraintNotNullToAdminUsers < ActiveRecord::Migration[5.2]
  def up
    change_column_null :admin_users, :user_name, false, ""
    change_column_null :admin_users, :email, false, ""
    change_column_null :admin_users, :password_digest, false, ""
    add_index :admin_users, :email, unique: true
  end

  def down
    change_column_null :admin_users, :user_name, true, nil
    change_column_null :admin_users, :email, true, nil
    change_column_null :admin_users, :password_digest, true, nil
    remove_index :admin_users, :email
  end
end
