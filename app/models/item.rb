class Item < ApplicationRecord
  belongs_to :query, inverse_of: :items
  accepts_nested_attributes_for :query
end
