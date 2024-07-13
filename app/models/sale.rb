class Sale < ApplicationRecord
  has_many :sale_items
  belongs_to :store_location
end
