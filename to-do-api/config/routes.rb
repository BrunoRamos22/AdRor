Rails.application.routes.draw do
  resources :tasks, except: [:new, :edit]
end
