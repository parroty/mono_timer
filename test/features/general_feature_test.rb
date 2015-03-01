require "test_helper"

describe "general feature", :capybara do
  it "gets redirected to timer#index when root page visited" do
    visit "/"

    assert_equal timers_path, current_path
    assert_content page, "Mono Timer"
  end

  it "displays the status of notifications" do
    visit "/"

    assert_content page, "Pushover"
    assert_content page, "Mailgun"
  end
end
