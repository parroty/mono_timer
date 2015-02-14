class PushoverNotifier
  def notify(message, title = "Mono Timer")
    response = Pushover.notification(message: message, title: title).response
    unless response.is_a?(Net::HTTPSuccess)
      fail "Sending notification failed with error: #{response.body}"
    end
  end
end
