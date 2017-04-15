class AddIdToQueries < ActiveRecord::Migration[5.0]
  def change
    add_column :queries, :query_id, :integer
  end
end
