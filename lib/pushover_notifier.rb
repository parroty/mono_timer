class PushoverNotifier
  def notify(message, title = 'Mono Timer')
    Pushover.notification(message: message, title: title)
  end
end
