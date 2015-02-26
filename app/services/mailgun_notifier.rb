class MailgunNotifier
  class << self
    attr_accessor :api_key, :domain, :address

    def configure
      yield self
    end
  end

  def initialize
    @client = Mailgun::Client.new(MailgunNotifier.api_key)
  end

  def notify(message, title = "Mono Timer")
    email = create_email(title, message)
    @client.send_message(MailgunNotifier.domain, email)
  end

  private

  def create_email(title, message)
    { from:    MailgunNotifier.address,
      to:      MailgunNotifier.address,
      subject: title,
      text:    message }
  end
end
