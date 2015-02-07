require 'test_helper'

class PushoverNotifierTest < ActiveSupport::TestCase
  test "sends message with default title" do
    Pushover.expects(:notification)
      .with(message: "sample message", title: "Mono Timer")

    PushoverNotifier.new.notify("sample message")
  end
end
