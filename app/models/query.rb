class Query < ApplicationRecord
  has_many :items, inverse_of: :query
  accepts_nested_attributes_for :items

  def min
    @item_query = Item.where(query_id: Item.last.query_id)
    @item_query.minimum(:price).to_i
  end

  def max
    @item_query = Item.where(query_id: Item.last.query_id)
    @item_query.maximum(:price).to_i
  end

  def spectrum(num)
    num / (min + max)
  end

end
