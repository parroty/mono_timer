Rails.application.routes.draw do
  root :to => redirect('/timer')
  resources :timer, except: [:show]
  get "timer/history"
  post "timer/:id/stop" => 'timer#stop', as: :timer_stop

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
