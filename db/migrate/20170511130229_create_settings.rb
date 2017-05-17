class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.belongs_to :user
      t.belongs_to :address

      t.timestamps
    end
  end
end
