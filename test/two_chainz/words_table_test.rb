require 'test_helper'

describe TwoChainz::WordsTable do
  before do
    @table = TwoChainz::WordsTable.new
  end

  describe 'increment' do
    it 'must error if there are no arguments' do
      assert_raises(ArgumentError) { @table.increment }
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
end
