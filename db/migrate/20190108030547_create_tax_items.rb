class CreateTaxItems < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_items do |t|
      t.string :name
      t.integer :tax_class

      t.timestamps
    end
  end
end
