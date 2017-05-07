class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :images
      t.string :title
      t.text :description
      t.float :price
      t.integer :quantity, default: 0
      t.boolean :is_hidden, default: true
      t.belongs_to :category

      t.timestamps
    end
  end
end
