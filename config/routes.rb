Rails.application.routes.draw do
  post '/survivor', to: 'survivor#create', as: :create_survivor
  post '/survivor/update_location', to: 'survivor#update_location', as: :update_location_survivor
end
