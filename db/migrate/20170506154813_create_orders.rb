class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :number
      t.string :payment_method
      t.float  :total_price, default: 0
      t.string :aasm_state, default: "placed"
      t.string :name
      t.string :cellphone
      t.string :address
      t.belongs_to :user
      t.index  :number, unique: true
      t.index  :aasm_state

      t.timestamps
    end
  end
end
