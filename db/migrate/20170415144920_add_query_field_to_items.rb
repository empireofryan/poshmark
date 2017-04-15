class AddQueryFieldToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :query, :string
  end
end
