class CreateAdminUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_users do |t|
      t.string :user_name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
