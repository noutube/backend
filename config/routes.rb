Rails.application.routes.draw do
  # API
  resources :users, only: [:show, :destroy]
  resources :subscriptions, only: [:index]
  resources :items, only: [:index, :update, :destroy]
  get 'push/:channel_id', to: 'push#validate'
  post 'push/:channel_id', to: 'push#callback', as: :push_callback

  # frontend
  get 'frontend', to: redirect('/', status: 302)
  mount_ember_app :frontend, to: '/'
end
