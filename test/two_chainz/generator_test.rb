require 'test_helper'

class TwoChainz::GeneratorTest < MiniTest::Unit::TestCase
  def test_new
    refute_nil TwoChainz::Generator.new, "TwoChainz::Generator#new should create a new TwoChainz::Generator"
  end
end
