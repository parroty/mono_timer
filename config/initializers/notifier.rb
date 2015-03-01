Rails.application.config.to_prepare do
  Notifier::Pushover.configure do |config|
    config.user  = ENV['PUSHOVER_USER_KEY']
    config.token = ENV['PUSHOVER_API_KEY']
  end

  Notifier::Mailgun.configure do |config|
    config.api_key = ENV["MAILGUN_API_KEY"]
    config.domain  = ENV["MAILGUN_DOMAIN"]
    config.address = ENV["MONO_TIMER_EMAIL"]
  end
end
