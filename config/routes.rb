# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'events#index'

  resources :events
end
