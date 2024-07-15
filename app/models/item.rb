class Item < ApplicationRecord
  belongs_to :item_category
  has_many :sale_items

  # Check if there are enogh quantities of an item in stock
  def check_quantity(purchased_quantity)
    (self.quantity - purchased_quantity) >= 0
  end

  # Create sale item for a sale
  def create_sale_item(sale, quantity)
    self.update(quantity: self.quantity - quantity)
    self.sale_items.create(
      sale_id: sale.id,
      name: self.name,
      price: self.price,
      quantity: quantity
    )
  end

  # convert decimal item price to a float
  def item_price
    self.price.to_f
  end
end
