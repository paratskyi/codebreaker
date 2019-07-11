module Exceptions
  class InvalidName < StandardError
    def initialize(msg = 'Name must be between 4 and 20 characters. Please, try again')
      super(msg)
    end
  end
end
