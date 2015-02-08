class PushoverNotifier
  def notify(message, title = 'Mono Timer')
    response = Pushover.notification(message: message, title: title)
    unless response.kind_of? Net::HTTPSuccess
      raise "Sending notification failed with error: #{response.body}"
    end
  end
end
