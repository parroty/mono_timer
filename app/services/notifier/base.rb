module Notifier
  class Base
    class << self
      def inherited(child)
        Notifier.handlers << child
      end
    end
  end
end
