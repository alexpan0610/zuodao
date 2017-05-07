class CreateReceivingInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :receiving_infos do |t|
      t.string :name
      t.string :cellphone
      t.string :address
      t.belongs_to :user

      t.timestamps
    end
  end
end
