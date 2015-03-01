class NotifierStatus
  attr_accessor :name, :enabled

  class << self
    def create
      Notifier.handlers.map do |handler|
        NotifierStatus.new.tap do |status|
          status.name    = handler.name
          status.enabled = handler.enabled
        end
      end
    end
  end
end
