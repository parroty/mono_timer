require "test_helper"

describe Notifier::Mailgun do
  describe "notify" do
    before do
      Notifier::Mailgun.configure do |config|
        config.api_key = "test_api_key"
        config.domain  = "test_domain"
        config.address = "test@test_domain.com"
      end
    end

    it "sends message with default title" do
      expected_message = {
        from:    "test@test_domain.com",
        to:      "test@test_domain.com",
        subject: "Mono Timer",
        text:    "Sample Message"
      }

      Mailgun::Client.any_instance.stubs(:send_message)
        .with("test_domain", expected_message)

      Notifier::Mailgun.new.notify("Sample Message")
    end

    it "sends message with custom title" do
      expected_message = {
        from:    "test@test_domain.com",
        to:      "test@test_domain.com",
        subject: "Sample Title",
        text:    "Sample Message"
      }

      Mailgun::Client.any_instance.stubs(:send_message)
        .with("test_domain", expected_message)

      Notifier::Mailgun.new.notify("Sample Message", "Sample Title")
    end
  end
end
