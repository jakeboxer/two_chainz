class TwoChainz::WordsTable
  # Public: Create a new TwoChainz::WordsTable instance.
  #
  # Returns a TwoChainz::WordsTable
  def initialize
    # The table is a hash. Think of its entries as "rows".
    # Each row is another hash. Think of its entries as "cells".
    # Cells default to 0.
    @table = {}
  end

  # Public: Increment the value in the table for the specified pair of words.
  #
  # first_word  - The word that comes first in the pair. If this is nil, the
  #               second word in the pair will be recorded as the beginning of
  #               a sentence.
  # second_word - The word that comes last in the pair. If this is nil or
  #               omitted, the first word in the pair will be recorded as the
  #               ending of a sentence.
  #
  # Returns the new count of the entry.
  def increment(first_word=nil, second_word=nil)
    # We need either a first word or a second word
    unless first_word || second_word
      raise ArgumentError, "At least one word must be provided to TwoChainz::WordsTable#increment"
    end

    # Only one of these will run, since we error if both are nil
    first_word  ||= :beginning
    second_word ||= :ending

    add_row(first_word)
    add_row(second_word) unless second_word == :ending

    @table[first_word][second_word]  += 1
  end

  # Public: Whether or not the words table has the specified word.
  #
  # word - Word to check for inclusion of.
  #
  # Returns a boolean
  def include?(word)
    @table.keys.include?(word)
  end

  # Public: Get all the words that have been incremented at least once.
  #
  # Returns an array.
  def words
    @table.keys - [:beginning]
  end

  # Public: Get all the words that have come after the specified word. In the
  # result, the keys are the words and the values are the number of times that
  # word has appeared after the specified word.
  #
  # Can also include the :ending key, which indicates that the sentence ended
  # after that word.
  #
  # word - Word to find all following words for
  #
  # Examples
  #
  #   increment('your', 'love')
  #   increment('your', 'time')
  #   increment('your', 'love')
  #   words_after('your')
  #   # => {"love" => 2, "time" => 1}
  #
  # Returns a hash.
  def words_after(word)
    Hash[@table[word] || {}]
  end

  private

  def add_row(word)
    @table[word] ||= Hash.new(0)
  end
end
