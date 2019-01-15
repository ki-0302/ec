class CreateTaxRates < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_rates do |t|
      t.string :name, null: false
      t.date :apply_start_date, null: false
      t.float :standard_tax_rate, null: false, default: 0
      t.float :reduced_tax_rate
      t.timestamps
    end
  end
end
