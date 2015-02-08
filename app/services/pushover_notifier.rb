class PushoverNotifier
  def notify(message, title = 'Mono Timer')
    response = Pushover.notification(message: message, title: title)
    if response.class != Net::HTTPSuccess
      raise "Sending notification failed with error: #{response.body}"
    end
  end
end
