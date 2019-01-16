class CreateSlideshows < ActiveRecord::Migration[5.2]
  def change
    create_table :slideshows do |t|
      t.string :name, null: false
      t.string :description
      t.string :url
      t.integer :priority, null: false, default: 0
      t.timestamps
    end
  end
end
