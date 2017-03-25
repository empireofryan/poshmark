class AddBrandUrlToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :brand, :string
    add_column :items, :price, :decimal
    add_column :items, :size, :string
    add_column :items, :href, :string
    add_column :items, :originalprice, :decimal
  end
end
