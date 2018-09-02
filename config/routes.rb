Rails.application.routes.draw do
  post '/survivor', to: 'survivor#create', as: :create_survivor
end
