class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.references :category, foreign_key: true, default: nil
      t.string :manufacture_name
      t.string :code
      t.references :tax_item, foreign_key: true, null: false
      t.integer :sales_price
      t.integer :regular_price
      t.integer :number_of_stocks
      t.boolean :unlimited_stock, null: false, default: true
      t.datetime :display_start_datetime
      t.datetime :display_end_datetime
      t.string :description
      t.string :search_term
      t.string :jan_code
      t.integer :status_code, null: false, default: 0
      t.timestamps
    end
  end
end
