require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

namespace :test do
  task :coverage do
    require "simplecov"
    SimpleCov.start "rails"
    Rake::Task["test"].execute
  end
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

