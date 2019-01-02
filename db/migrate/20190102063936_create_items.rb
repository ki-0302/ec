class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :category_id
      t.string :manufacture_name
      t.string :code
      t.integer :tax_item_id
      t.integer :sales_price
      t.integer :regular_price
      t.integer :number_of_stocks
      t.boolean :unlimited_stock, null: false, default: false
      t.datetime :display_start_date
      t.datetime :display_end_date
      t.string :description
      t.string :search_term
      t.string :jan_code
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :items, :code, unique: true
  end
end
