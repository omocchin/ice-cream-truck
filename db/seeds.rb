store_locations = [
  {
    name: 'Hawaii',
    tax: '4.712'
  },
  {
    name: 'Calofornia',
    tax: '7.25'
  }
]

items = [
  {
    category_name: 'Ice Cream',
    items: [
      {
        name: 'Chocolate',
        price: 6.50,
        quantity: 10
      },
      {
        name: 'Pistachio',
        price: 7.25,
        quantity: 10
      },
      {
        name: 'Strawberry',
        price: 7.00,
        quantity: 10
      },
      {
        name: 'Mint',
        price: 7.00,
        quantity: 10
      },
    ]
  },
  {
    category_name: 'Others',
    items: [
      {
        name: 'Shaved Ice',
        price: 6.00,
        quantity: 5
      },
      {
        name: 'Chocolate Bar',
        price: 1.25,
        quantity: 50
      }
    ]
  }
]

ActiveRecord::Base.transaction do
  store_locations.each do |store|
    location = StoreLocation.create(name: store[:name])
    location.create_setting(tax_percentage: store[:tax])
    items.each do |item_category|
      category = location.item_categories.create(name: item_category[:category_name])
      item_category[:items].each do |item|
        category.items.create(name: item[:name], price: item[:price], quantity: item[:quantity])
      end
    end
  end
end