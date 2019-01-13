class CreateTaxItems < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_items do |t|
      t.string :name
      t.references :tax_class, foreign_key: true, default: 1
      t.timestamps
    end
  end
end