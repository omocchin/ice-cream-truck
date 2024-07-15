class Sale < ApplicationRecord
  has_many :sale_items
  belongs_to :store_location

  # Get totals of a sale and apply to self
  def apply_totals(items)
    subtotal = 0
    items.each do |purchased_item|
      item = Item.find(purchased_item[:id])
      subtotal += (item.item_price * purchased_item[:order_quantity])
    end
    tax_total = (subtotal * self.store_location.setting.tax_to_percent).round(2)
    total = subtotal + tax_total
    self.update(
      subtotal: subtotal,
      tax_total: tax_total,
      total: total
    )
    self
  end
end
