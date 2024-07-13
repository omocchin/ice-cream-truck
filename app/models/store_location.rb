class StoreLocation < ApplicationRecord
  has_many :item_categories
  has_many :sales
  has_one :settings
end
