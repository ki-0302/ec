class CreateGeneralSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :general_settings do |t|

      t.timestamps
    end
  end
end
