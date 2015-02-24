source "https://rubygems.org"

ruby "2.2.0"

gem "rails", "4.2.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc

group :production do
  gem "pg"
end

group :development do
  gem "pry-rails"
  gem "rubocop", require: false
end

group :test do
  gem "simplecov", require: false
  gem "coveralls", require: false
end

group :development, :test do
  gem "byebug"
  gem "factory_girl_rails"
  gem "minitest-rails-capybara"
  gem "minitest-reporters"
  gem "mocha", require: "mocha/api"
  gem "newrelic_rpm"
  gem "spring"
  gem "sqlite3"
  gem "timecop"
  gem "web-console", "~> 2.0"
end

gem "ruby-enum"
gem "kaminari"
gem "unicorn"
gem "pushover"
gem "sidekiq"
gem "simple_form"
gem "sinatra", require: nil
gem "twitter-bootstrap-rails"
