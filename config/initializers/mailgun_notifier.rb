MailgunNotifier.configure do |config|
  config.api_key = ENV["MAILGUN_API_KEY"]
  config.domain  = ENV["MAILGUN_DOMAIN"]
  config.address = ENV["MONO_TIMER_EMAIL"]
end
