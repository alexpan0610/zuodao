class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.belongs_to :cart
      t.belongs_to :product
      t.integer :cart_items_count

      t.timestamps
    end
  end
end
