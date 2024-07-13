class Item < ApplicationRecord
  belongs_to :item_category
  has_many :sale_items
end
