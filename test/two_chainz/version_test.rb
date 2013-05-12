require 'test_helper'

class TwoChainz::VersionTest < MiniTest::Unit::TestCase
  def test_existence
    refute_nil TwoChainz::VERSION, 'TwoChainz::VERSION should not be nil'
  end
end
