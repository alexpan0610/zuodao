class AddCatalogToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :catalog, :text
  end
end
