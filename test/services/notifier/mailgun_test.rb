require "test_helper"

describe Notifier::Mailgun do
  before do
    Notifier::Mailgun.configure do |config|
      config.api_key = "test_api_key"
      config.domain  = "test_domain"
      config.address = "test@test_domain.com"
    end
    @api_key = Notifier::Mailgun.api_key
    @domain  = Notifier::Mailgun.domain
    @address = Notifier::Mailgun.address
  end

  describe "configure" do
    it "prepares mailgun parameters" do
      assert_equal "test_api_key", @api_key
      assert_equal "test_domain",  @domain
      assert_equal "test@test_domain.com", @address
    end
  end

  describe "notify" do
    describe "with valid configuration" do
      it "sends message with default title" do
        expected_message = {
          from:    @address,
          to:      @address,
          subject: "Mono Timer",
          text:    "Sample Message"
        }

        Mailgun::Client.any_instance.stubs(:send_message)
          .with("test_domain", expected_message)

        Notifier::Mailgun.new.notify("Sample Message")
      end

      it "sends message with custom title" do
        expected_message = {
          from:    @address,
          to:      @address,
          subject: "Sample Title",
          text:    "Sample Message"
        }

        Mailgun::Client.any_instance.stubs(:send_message)
          .with("test_domain", expected_message)

        Notifier::Mailgun.new.notify("Sample Message", "Sample Title")
      end
    end

    describe "with invalid configuration" do
      before do
        Notifier::Mailgun.configure do |config|
          config.api_key = nil
        end
      end

      it "should not send notification" do
        Mailgun::Client.any_instance.stubs(:send_message).never

        Notifier::Mailgun.new.notify("Sample Message", "Sample Title")
      end
    end
  end
end
