require "test_helper"

class GeneralFeatureTest < Capybara::Rails::TestCase
  test "root page redirects to timer#index" do
    visit "/"
    assert_equal timer_index_path, current_path
    assert_content page, "Mono Timer"
  end
end
