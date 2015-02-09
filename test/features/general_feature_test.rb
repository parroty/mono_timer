require "test_helper"

describe "general feature", :capybara do
  it "gets redirected to timer#index when root page visited" do
    visit "/"
    assert_equal timer_index_path, current_path
    assert_content page, "Mono Timer"
  end
end
