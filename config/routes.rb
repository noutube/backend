Rails.application.routes.draw do
  # auth
  get 'auth', to: 'auth#new'
  get 'auth/callback', to: 'auth#callback', as: :auth_callback
  get 'auth/sign_in', to: 'auth#sign_in'

  # client
  resources :users, only: [:show, :destroy]
  resources :subscriptions, only: [:index]
  resources :items, only: [:index, :update, :destroy]

  # pubsub
  get 'push/:channel_id', to: 'push#validate'
  post 'push/:channel_id', to: 'push#callback', as: :push_callback

  # frontend
  get 'frontend', to: redirect('/', status: 302)
  mount_ember_app :frontend, to: '/'
end
