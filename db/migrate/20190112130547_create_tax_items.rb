class CreateTaxItems < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_items do |t|
      t.string :name
      t.references :tax_class, foreign_key: { to_table: :tax_classes }, default: 1
      t.timestamps
    end
  end
end
