require 'test_helper'

describe TwoChainz::Generator do
  before do
    @generator = TwoChainz::Generator.new(:boring => true)
  end

  describe 'new' do
    it 'must create a new instance of TwoChainz::Generator with no arguments' do
      g = TwoChainz::Generator.new
      refute_nil g, "TwoChainz::Generator.new should create a new TwoChainz::Generator"
    end

    it 'must create a new instance of TwoChainz::Generator with a seed' do
      g = TwoChainz::Generator.new(:seed => 3)
      refute_nil g, "TwoChainz::Generator.new should create a new TwoChainz::Generator"
    end

    it 'must create a new instance of TwoChainz::Generator in boring mode' do
      g = TwoChainz::Generator.new(:boring => true)
      refute_nil g, "TwoChainz::Generator.new should create a new TwoChainz::Generator"
    end
  end

  describe 'hear' do
    it 'must work when an empty string is passed' do
      assert @generator.hear('')
    end

    it 'must work when a one-word string is passed' do
      assert @generator.hear('sup')
    end

    it 'must work when a string with two of the same words are passed' do
      assert @generator.hear('yo yo')
    end

    it 'must work when a string with two different words are passed' do
      assert @generator.hear('love you')
    end
  end

  describe 'spit' do
    it 'must not throw out symbols' do
      @generator.hear('how u #doin ++today++ man and :+1: to you')
      assert_equal 'how u #doin ++today++ man and :+1: to you', @generator.spit(:words => 9)
    end

    it 'must be able to start a new chain if the sentence should end' do
      @generator.hear('drive slow homie')
      assert_equal 'drive slow homie drive slow homie drive', @generator.spit(:words => 7)
    end

    it 'must ignore URLs it has heard' do
      @generator.hear("yo i was at http://zombo.com/ the other day and that shit's still up")
      assert_equal "yo i was at the other day and that shit's still up", @generator.spit(:words => 12)
    end

    describe '@mention style tokens' do
      it 'must ignore them in the beginning of sentences' do
        @generator.hear("@jakeboxer don't be in this tweet")
        assert_equal "don't be in this tweet", @generator.spit(:words => 5)
      end

      it 'must ignore them in the middle of sentences' do
        @generator.hear("hey @jakeboxer don't be in this tweet")
        assert_equal "hey don't be in this tweet", @generator.spit(:words => 6)
      end
    end

    describe 'with no options provided' do
      it 'must raise an ArgumentError' do
        @generator.hear('irrelevant')
        assert_raises(ArgumentError) { @generator.spit }
      end

      it "must raise a StandardError when it hasn't heard anything" do
        assert_raises(StandardError) { @generator.spit }
      end
    end

    describe 'with the :words option provided' do
      it "must return an empty string when :words is 0" do
        @generator.hear('irrelevant')
        assert_empty @generator.spit(:words => 0)
      end

      it "must return a one-word string when it has only heard one word" do
        @generator.hear('sup')
        assert_equal 'sup', @generator.spit(:words => 1)
      end

      it "must return a two-word string when it's heard a two-word string" do
        @generator.hear('love you')
        assert_equal 'love you', @generator.spit(:words => 2)
      end

      it "must return a two-word string when it's heard multiple two-word strings" do
        @generator.hear('love you')
        @generator.hear('love me')
        @generator.hear('love me')
        @generator.hear('you suck')
        assert_equal 'love me', @generator.spit(:words => 2)
      end
    end

    describe 'with the :max_chars option provided' do
      it 'must return an empty string when :max_chars is 0' do
        @generator.hear('irrelevant')
        assert_empty @generator.spit(:max_chars => 0)
      end

      it 'must return an empty string when all words are longer than max_chars' do
        @generator.hear('incredibly')
        assert_empty @generator.spit(:max_chars => 9)
      end

      it "must return a one-letter string when it's only heard a one-letter word" do
        @generator.hear('a')
        assert_equal 'a', @generator.spit(:max_chars => 1)
      end

      it "must stay under the character limit" do
        @generator.hear("i've felt the ground before")
        assert_equal "i've felt", @generator.spit(:max_chars => 12)
      end

      it "must come as close to the character limit as it can" do
        @generator.hear("i've felt the ground before")
        assert_equal "i've felt the", @generator.spit(:max_chars => 13)
      end
    end
  end
end
