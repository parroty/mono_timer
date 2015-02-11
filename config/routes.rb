Rails.application.routes.draw do
  root :to => redirect('/timer')
  resources :timer, except: [:show]
  get "timer/history"
  post "timer/:id/stop" => 'timer#stop', as: :timer_stop
  post "timer/:id/pause" => 'timer#pause', as: :timer_pause
  post "timer/:id/resume" => 'timer#resume', as: :timer_resume

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
