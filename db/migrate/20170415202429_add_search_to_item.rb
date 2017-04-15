class AddSearchToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :search, :string
  end
end
