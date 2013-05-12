class TwoChainz::Generator
  attr_accessor :words_table

  def initialize
    @words_table = {}
  end

  # Public: Hear some words and remember them for future spitting.
  #
  # words - String of words to hear.
  #
  # Returns the number of unique new words the generator heard (integer)
  def hear(words)
    heard = 0

    words.scan(/[\w\']+/) do |word|
      heard += 1 unless words_table[word]
      words_table[word] = true
    end

    heard
  end
end
