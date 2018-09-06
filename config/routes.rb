Rails.application.routes.draw do
  post '/survivor', to: 'survivor#create', as: :create_survivor
  post '/survivor/update_location', to: 'survivor#update_location', as: :update_location_survivor
  post '/survivors/trade', to: 'inventory#trade', as: :survivors_trade_resource
  post '/survivor/report_infectation', to: 'infectation#report', as: :report_infectation_survivor
end
