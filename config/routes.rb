Rails.application.routes.draw do
  root :to => redirect('/timers')

  get  "timers/history"
  post "timers/:id/stop"   => 'timers#stop',   as: :timer_stop
  post "timers/:id/pause"  => 'timers#pause',  as: :timer_pause
  post "timers/:id/resume" => 'timers#resume', as: :timer_resume
  get  "timers/:id/pauses" => 'pauses#index',  as: :timer_pauses
  resources :timers, only: [:index, :create, :destroy, :show]

  require 'sidekiq/web'

  user = ENV['SIDEKIQ_MANAGEMENT_USER']
  pass = ENV['SIDEKIQ_MANAGEMENT_PASS']

  if user != nil && pass != nil
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == user && password == user
    end
  end
  mount Sidekiq::Web => '/sidekiq'
end
