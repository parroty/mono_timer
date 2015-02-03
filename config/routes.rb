Rails.application.routes.draw do
  root :to => redirect('/timer')
  resources :timer, except: [:show]
  get "timer/history"
  post "timer/stop"
end
