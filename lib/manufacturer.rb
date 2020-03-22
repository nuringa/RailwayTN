module Manufacturer
  extend Accessors

  attr_accessor_with_history :manufacturer
  strong_attr_accessor('test_strong', String)
end
