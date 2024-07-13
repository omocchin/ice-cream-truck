class ItemCategory < ApplicationRecord
  belongs_to :store_location
  has_many :items
end
