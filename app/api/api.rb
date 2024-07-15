class API < Grape::API
  prefix 'api'
  mount Resources::V1::Root
end