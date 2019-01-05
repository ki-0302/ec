class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.references :parent, foreign_key: { to_table: :categories }, default: nil
      t.string :name, null: false
      t.datetime :display_start_datetime
      t.datetime :display_end_datetime
      t.timestamps
    end
  end
end
