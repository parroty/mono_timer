module Notifier
  class Mailgun < Base
    class << self
      attr_accessor :api_key, :domain, :address

      def configure
        yield self
      end

      def enabled
        !api_key.nil? && !domain.nil? && !address.nil?
      end

      def name
        "Mailgun"
      end
    end

    def initialize
      @client = ::Mailgun::Client.new(Mailgun.api_key)
    end

    def notify(message, title = "Mono Timer")
      return unless Mailgun.enabled
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
