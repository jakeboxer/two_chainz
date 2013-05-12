require 'test_helper'

describe TwoChainz::Generator do
  before do
    @generator = TwoChainz::Generator.new(1)
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

  describe 'spit' do
    describe 'with no options provided' do
      it 'must raise an ArgumentError' do
        assert_raises(ArgumentError) { @generator.spit }
      end
    end

    describe 'with the :max_words option provided' do
      it "must return an empty string when it hasn't heard anything" do
        assert_empty @generator.spit(:max_words => 10)
      end

      it "must return a one-word string when it has only heard one word" do
        @generator.hear('sup')
        assert_equal 'sup', @generator.spit(:max_words => 10)
      end

      it "must return a two-word string when it's heard two words" do
        @generator.hear('love you')
        assert_equal 'love you', @generator.spit(:max_words => 10)
      end
    end
  end
end
