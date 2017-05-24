class AddProductIdToOrderDetail < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_details, :product, index: true
  end
end
