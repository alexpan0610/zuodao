class AddFavoritesCountToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :favorites_count, :integer, default: 0
  end
end
