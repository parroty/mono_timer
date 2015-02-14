require "test_helper"

describe PushoverNotifier do
  describe "when succeeds" do
    before do
      @httparty_response = stub(response: Net::HTTPOK.new(nil, 200, nil))
    end

    it "sends message with default title" do
      Pushover.expects(:notification)
        .with(message: "Sample Message", title: "Mono Timer")
        .returns(@httparty_response)

      PushoverNotifier.new.notify("Sample Message")
    end

    it "sends message with custom title" do
      Pushover.expects(:notification)
        .with(message: "Sample Message", title: "Sample Title")
        .returns(@httparty_response)

      PushoverNotifier.new.notify("Sample Message", "Sample Title")
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
        .with(message: "Sample Message", title: "Mono Timer")
        .returns(@httparty_response)

      error_message = assert_raises RuntimeError do
        PushoverNotifier.new.notify("Sample Message")
      end
      assert_match "error_message_body", error_message.to_s
    end
  end
end
