require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'

require 'two_chainz'

# Assert that the two ordered collections contain the same elements, regardless
# of order.
def assert_equal_without_order(expected, actual, message = nil)
  assert_equal expected.sort, actual.sort, message
end
