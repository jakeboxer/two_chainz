require 'test_helper'

describe TwoChainz::WordsTable do
  before do
    @table = TwoChainz::WordsTable.new
  end

  describe 'increment' do
    it 'must return 0 when there are no arguments' do
      assert_equal 0, @table.increment
    end

    it 'must return the correct value when there is one argument' do
      assert_equal 1, @table.increment('chainz')
      assert_equal 2, @table.increment('chainz')
    end

    describe 'when there are two arguments' do
      it 'must return the correct value when the first argument is nil' do
        assert_equal 1, @table.increment(nil, 'chainz')
        assert_equal 2, @table.increment(nil, 'chainz')
      end

      it 'must return the correct value when the second argument is nil' do
        assert_equal 1, @table.increment('chainz', nil)
        assert_equal 2, @table.increment('chainz', nil)
      end

      it 'must return the correct value when neither argument is nil' do
        assert_equal 1, @table.increment('two', 'chainz')
        assert_equal 2, @table.increment('two', 'chainz')
      end
    end
  end

  describe 'include?' do
    it 'must be true if the word is in the table' do
      @table.increment('chainz')
      assert @table.include?('chainz')
    end

    it 'must be false if the word is not in the table' do
      refute @table.include?('chainz')
    end
  end

  describe 'words' do
    it 'must return every word that has been incremented' do
      words = %w(when everything's wrong you make it right)
      increment_words(@table, words)

      assert_equal_without_order words, @table.words
    end

    it 'must return each word only once' do
      increment_words(@table, %w(i need your love i need your time))
      assert_equal_without_order %w(i need your love time), @table.words
    end
  end

  describe 'words_after' do
    it 'must return a hash of all the words that have come after the specified word' do
      @table.increment('your', 'love')
      @table.increment('your', 'love')
      @table.increment('your', 'time')
      @table.increment('hammer', 'time')
      @table.increment('ass', 'quake')

      assert_equal({'love' => 2, 'time' => 1}, @table.words_after('your'))
    end

    it 'must include :ending if it was used as the last word' do
      @table.increment('broken', 'hearted')
      @table.increment('broken')

      assert_equal({'hearted' => 1, :ending => 1}, @table.words_after('broken'))
    end

    it 'must ignore case on lookup' do
      @table.increment('bAbY', 'doll')

      # Note the capitalization difference between the increment and the lookup
      assert_equal({'doll' => 1}, @table.words_after('BaBy'))
    end
  end

  ##################
  # Helper methods #
  ##################

  def increment_words(table, words)
    prev = nil

    words.each do |word|
      table.increment(prev, word)
      prev = word
    end
  end
end
