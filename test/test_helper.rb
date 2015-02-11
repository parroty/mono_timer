ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'minitest/rails/capybara'
require 'minitest/reporters'
require 'mocha/setup'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def js_for_remaining_time(seconds)
  /window.remainingSeconds.+=.+'#{seconds}'/
end

def js_for_timer_state(state)
  /window.isCountingDown.+'#{state[:counting_down]}'/
end
