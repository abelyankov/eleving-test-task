# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments do
    post :start, on: :member
    resources :participants, module: :tournaments, only: %w[index new create destroy] do
      post :generate, on: :collection
      get :new_team, on: :collection
    end
    resources :division_games, module: :tournaments, only: %w[index destroy new create] do
      post :generate, on: :collection
    end

    resources :playoff, module: :tournaments, only: %w[index destroy] do
      post :generate, on: :collection
    end
    resources :quarter_final, module: :tournaments, only: %w[index destroy] do
      post :generate, on: :collection
    end
    resources :final, module: :tournaments, only: %w[index destroy] do
      post :generate, on: :collection
    end
  end
  resources :teams
end
