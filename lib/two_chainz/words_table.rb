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
  def increment(first_word=:beginning, second_word=:ending)
    if first_word == :beginning && second_word == :ending
      raise ArgumentError, "At least one word must be provided to TwoChainz::WordsTable#increment"
    end

    @table[first_word]              ||= Hash.new(0)
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
end
