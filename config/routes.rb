Rails.application.routes.draw do
  resources :users, only: [] do
    resources :carts, only: %w[index create show destroy] do
      resources :line_items, only: %w[create update destroy]
    end
  end
end
