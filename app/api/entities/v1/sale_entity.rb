module Entities
  module V1
    class SaleEntity < Grape::Entity
      class CreateSale < Grape::Entity
        expose :message
      end
    end
  end
end