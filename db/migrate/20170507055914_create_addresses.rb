class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :label
      t.string :name
      t.string :cellphone
      t.string :address
      t.belongs_to :user

      t.timestamps
    end
  end
end
