module Notifier
  class Mailgun < Base
    class << self
      attr_accessor :api_key, :domain, :address

      def configure
        yield self
      end
    end

    def initialize
      @client = ::Mailgun::Client.new(Mailgun.api_key)
    end

    def notify(message, title = "Mono Timer")
      email = create_email(title, message)
      @client.send_message(Mailgun.domain, email)
    end

    private

    def create_email(title, message)
      { from:    Mailgun.address,
        to:      Mailgun.address,
        subject: title,
        text:    message }
    end
  end
end
