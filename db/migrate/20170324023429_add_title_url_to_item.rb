class AddTitleUrlToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :title, :string
    add_column :items, :url, :string
  end
end
