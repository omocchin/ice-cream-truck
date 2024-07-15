module Resources
  module V1
    class Sale < Grape::API
      resources :sale do
        desc 'create sale'
        params do
          requires :store_location_id, type: Integer
          requires :paid_amount, type: BigDecimal
          requires :items, type: Array[JSON] do
            requires :id, type: Integer
            requires :order_quantity, type: Integer
          end
        end
        post do
          ActiveRecord::Base.transaction do
            store = StoreLocation.find(params[:store_location_id])
            sale = store.sales.new.apply_totals(params[:items])
            params[:items].each do |purchase_item|
              item = Item.find(purchase_item[:id])
              # Raise error if there are not enough stock for an item
              raise Exceptions::InsufficientQuantity unless item.check_quantity(purchase_item[:order_quantity])
              item.create_sale_item(sale, purchase_item[:order_quantity])
            end
          end
          response = {
            message: 'ENJOY!'
          }
          present response, with: Entities::V1::SaleEntity::CreateSale
        rescue  Exceptions::InsufficientQuantity => e
          Rails.logger.error(e.full_message)
          error!('SO SORRY!', 422)
        rescue StandardError => e
          Rails.logger.error(e.full_message)
          error!('Something went wrong!', 500)
        end
      end
    end
  end
end