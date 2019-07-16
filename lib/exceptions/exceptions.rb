module Exceptions
  class InvalidName < StandardError
    def initialize(msg = I18n.t(:InvalidName))
      super(msg)
    end
  end
  class InvalidCommand < StandardError
    def initialize(msg = I18n.t(:InvalidCommand))
      super(msg)
    end
  end
end
