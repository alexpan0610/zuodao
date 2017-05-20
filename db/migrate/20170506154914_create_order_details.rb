class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.string :image
      t.string :title
      t.text :description
      t.float :price
      t.integer :quantity, default: 0
      t.belongs_to :order

      t.timestamps
    end
  end
end
