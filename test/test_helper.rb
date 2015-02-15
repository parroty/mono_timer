require "coveralls"
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/pride"
require "minitest/rails/capybara"
require "minitest/reporters"
require "mocha/setup"
require "sidekiq/testing"

Sidekiq::Testing.fake!

module ActiveSupport
  class TestCase
    fixtures :all
  end
end

def js_for_remaining_time(seconds)
  /window.remainingSeconds.+=.+#{seconds}/
end

def js_for_timer_state(state)
  /window.isCountingDown.+#{state[:counting_down]}/
end
