require "test_helper"

describe "notification feature", :capybara do
  it "displays the status of notifications in the index page" do
    visit "/"

    assert_content page, "Pushover"
    assert_content page, "Mailgun"
  end
end
