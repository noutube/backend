Rails.application.routes.draw do
  # auth
  post 'tokens', to: 'tokens#create'
  get 'tokens/valid', to: 'tokens#valid'

  # client
  resources :users, only: [:create, :show, :update, :destroy]
  resources :channels, only: [:index]
  resources :videos, only: [:index, :update, :destroy]
  post 'channels/takeout', to: 'channels#takeout', format: 'application/json'

  # pubsub
  get 'push/:channel_id', to: 'push#validate'
  post 'push/:channel_id', to: 'push#callback', as: :push_callback
end
