module Notifier
  class << self
    def handlers
      @handlers ||= []
    end

    def execute(message)
      handlers.each do |handler|
        handler.new.notify(message)
      end
    end
  end
end
