require 'test_helper'

describe TwoChainz::Generator do
  before do
    @generator = TwoChainz::Generator.new
  end

  describe 'new' do
    it 'must create a new instance of TwoChainz::Generator' do
      refute_nil @generator, "TwoChainz::Generator#new should create a new TwoChainz::Generator"
    end
  end

  describe 'hear' do
    it 'must return 0 when an empty string is passed' do
      assert_equal 0, @generator.hear('')
    end

    it 'must return 1 when a one-word string is passed' do
      assert_equal 1, @generator.hear('sup')
    end

    it 'must return 1 when a string with two of the same words are passed' do
      assert_equal 1, @generator.hear('yo yo')
    end

    it 'must return 2 when a string with two different words are passed' do
      assert_equal 2, @generator.hear('love you')
    end
  end
end
