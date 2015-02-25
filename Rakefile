require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

unless Rails.env.production?
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
end
