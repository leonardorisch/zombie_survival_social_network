Rails.application.routes.draw do
  post '/events', to: 'webhooks_api#create', as: :webhook
  get '/issue/:issue_id/events', to: 'issue_events#show', as: :issue_events
  get '/issue/:issue_id/events/:action_type', to: 'issue_events#show_by_action_type', as: :issue_events_by_action
end
