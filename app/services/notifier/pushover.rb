module Notifier
  class Pushover < Base
    class << self
      attr_accessor :user, :token

      def configure
        yield self
      end

      def enabled
        !user.nil? && !token.nil?
      end

      def name
        "Pushover"
      end
    end

    def notify(message, title = "Mono Timer")
      return unless Pushover.enabled

      response =
        ::Pushover.notification(
          message: message, title: title,
          user: Pushover.user, token: Pushover.token).response

      unless response.is_a?(Net::HTTPSuccess)
        fail "Sending notification failed with error: #{response.body}"
      end
    end
  end
end
