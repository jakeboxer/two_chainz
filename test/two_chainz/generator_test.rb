require 'test_helper'

describe TwoChainz::Generator do
  describe 'new' do
    it 'must create a new instance of TwoChainz::Generator' do
      refute_nil TwoChainz::Generator.new, "TwoChainz::Generator#new should create a new TwoChainz::Generator"
    end
  end
end
