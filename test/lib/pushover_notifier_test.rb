require 'test_helper'

class PushoverNotifierTest < ActiveSupport::TestCase
  test "sends message succeeds with default title" do
    response = mock()
    response.expects(:class).returns(Net::HTTPSuccess)
    Pushover.expects(:notification)
      .with(message: "Sample Message", title: "Mono Timer").returns(response)

    PushoverNotifier.new.notify("Sample Message")
  end

  test "sends message succeeds with custom title" do
    response = mock()
    response.expects(:class).returns(Net::HTTPSuccess)
    Pushover.expects(:notification)
      .with(message: "Sample Message", title: "Sample Title").returns(response)

    PushoverNotifier.new.notify("Sample Message", "Sample Title")
  end

  test "send message fails" do
    response = mock()
    response.expects(:class).returns(Net::HTTPBadRequest)
    response.expects(:body).returns("error")
    Pushover.expects(:notification)
      .with(message: "Sample Message", title: "Mono Timer").returns(response)

    error_message = assert_raises RuntimeError do
      PushoverNotifier.new.notify("Sample Message")
    end
    assert_match "error", error_message.to_s
  end
end
