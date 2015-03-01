require "test_helper"

describe Notifier::Pushover do
  before do
    Notifier::Pushover.configure do |config|
      config.user  = "dummy_user"
      config.token = "dummy_token"
    end
    @user  = Notifier::Pushover.user
    @token = Notifier::Pushover.token
  end

  describe "configuration" do
    it "returns specified parameters" do
      assert_equal "dummy_user", @user
      assert_equal "dummy_token", @token
    end
  end

  describe "notify" do
    describe "when succeeds" do
      before do
        @httparty_response = stub(response: Net::HTTPOK.new(nil, 200, nil))
      end

      it "sends message with default title" do
        Pushover.expects(:notification)
          .with(message: "Sample Message", title: "Mono Timer",
                user: @user, token: @token)
          .returns(@httparty_response)

        Notifier::Pushover.new.notify("Sample Message")
      end

      it "sends message with custom title" do
        Pushover.expects(:notification)
          .with(message: "Sample Message", title: "Sample Title",
                user: @user, token: @token)
          .returns(@httparty_response)

        Notifier::Pushover.new.notify("Sample Message", "Sample Title")
      end
    end

    describe "when fails" do
      before do
        http_response = Net::HTTPBadRequest.new(nil, 400, nil)
        http_response.expects(:body).returns("error_message_body")
        @httparty_response = stub(response: http_response)
      end

      it "throws RuntimeError" do
        Pushover.expects(:notification)
          .with(message: "Sample Message", title: "Mono Timer",
                user: @user, token: @token)
          .returns(@httparty_response)

        error_message = assert_raises RuntimeError do
          Notifier::Pushover.new.notify("Sample Message")
        end
        assert_match "error_message_body", error_message.to_s
      end
    end

    describe "with invalid configuration" do
      before do
        Notifier::Pushover.configure do |config|
          config.user = nil
        end
      end

      it "should not send notification" do
        ::Pushover.expects(:notification).never

        Notifier::Pushover.new.notify("Sample Message")
      end
    end
  end
end
