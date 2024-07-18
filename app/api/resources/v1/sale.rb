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

      resource :sale_inventory do
        route_param :location_id, type: Integer do
          params do
            optional :from, type: String, regexp: /^\d{4}-\d{2}-\d{2}$/
            optional :to, type: String, regexp: /\d{4}-\d{2}-\d{2}/
          end
          get do
            store = StoreLocation.find(params[:location_id])
            inventory = store.all_inventory
            if params[:from] && params[:to]
              date_from = Date.parse(params[:from]).beginning_of_day
              date_to = Date.parse(params[:to]).end_of_day
              sales = store.sales_between_dates(date_from, date_to)
            else
              sales = store.all_sales
            end
            response = {
              total_sales: ActionController::Base.helpers.number_to_currency(sales),
              inventory: inventory              
            }
            present response, with: Entities::V1::SaleEntity::SaleInventory
          rescue StandardError => e
            Rails.logger.error(e.full_message)
            error!('Something went wrong!', 500)
          end
        end
      end
    end
  end
end