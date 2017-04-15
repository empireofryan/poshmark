class Query < ApplicationRecord
  has_many :items, inverse_of: :query
  accepts_nested_attributes_for :items
end
