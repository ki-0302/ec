class CreateTaxClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_classes do |t|
      t.string :name, unique: true
      t.float :tax_rate, null: false, default: 0
      t.timestamps
    end
    add_index :tax_classes, :name, unique: true
  end
end
