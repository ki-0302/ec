class CreateGeneralSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :general_settings do |t|
      t.string :site_name, null: false
      t.string :postal_code
      t.string :region
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :phone_number
      t.timestamps
    end
  end
end
