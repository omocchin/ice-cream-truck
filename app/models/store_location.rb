class StoreLocation < ApplicationRecord
  has_many :item_categories
  has_many :items, through: :item_categories
  has_many :sales
  has_one :setting

  # get all inventories of the items by category
  def all_inventory
    item_categories.includes(:items).map do |category|
      {
        category_name: category.name,
        items: category.items.map { |item| { id: item.id, name: item.name, quantity: item.quantity } }
      }
    end
  end

  # get sales of the location between specific dates
  def sales_between_dates(from, to)
    self.sales.where(created_at: from..to).sum(:total)
  end

  # get sales of all time
  def all_sales
    self.sales.sum(:total)
  end
end
