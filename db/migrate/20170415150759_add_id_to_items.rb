class AddIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :query_id, :integer
  end
end
