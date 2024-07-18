module Entities
  module V1
    class SaleEntity < Grape::Entity
      class CreateSale < Grape::Entity
        expose :message
      end

      class SaleInventory < Grape::Entity
        expose :total_sales
        expose :inventory
      end
    end
  end
end