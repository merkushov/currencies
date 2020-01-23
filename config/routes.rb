require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      get '/currencies', to: 'currencies#index'
      get '/currency/:code', to: 'currencies#show'
    end
  end
end
