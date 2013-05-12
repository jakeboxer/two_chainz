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

  # Public: Produce a randomized sentence based on the words that have been
  # heard.
  #
  # options - Hash of options. At least one is required.
  #
  #           :max_words - (Integer) the maximum number of words to be
  #                        generated
  #
  # Returns a string.
  def spit(options = {})
    raise ArgumentError, 'The :max_words option must be provided'
  end
end
