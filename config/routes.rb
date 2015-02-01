Rails.application.routes.draw do
  root :to => redirect('/timer')
  resources :timer, :only => [:index]
  get 'timer/new'
  get "timer/list"
end
