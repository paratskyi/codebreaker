module Validating
  def valid_name?(name = '')
    name.length < 4 || name.length > 20
  end
end
