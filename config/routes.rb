Rails.application.routes.draw do
  # auth

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # admin

  ActiveAdmin.routes(self)

  # frontend

  mount_ember_app :frontend, to: '/frontend', controller: 'frontend'

  root to: redirect('/frontend/', status: 302)

  # API

  resources :subscriptions, only: [:index]
  resources :items, only: [:index, :update, :destroy]
end
