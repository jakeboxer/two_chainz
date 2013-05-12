class TwoChainz::Generator
  # Public: Create a new TwoChainz::Generator instance.
  #
  # seed - (Optional integer) Seed to use when spitting. If nothing is provided,
  #        Ruby core's Random::new_seed will be used.
  #
  # Returns a TwoChainz::Generator
  def initialize(seed = nil)
    @words_table = {}
    @random      = seed ? Random.new(seed) : Random.new
  end

  # Public: Hear some words and remember them for future spitting.
  #
  # words - String of words to hear.
  #
  # Returns the number of unique new words the generator heard (integer)
  def hear(words)
    heard = 0

    words.scan(/[\w\']+/) do |word|
      heard += 1 unless @words_table[word]
      @words_table[word] = true
    end

    heard
  end

  # Public: Produce a randomized sentence based on the words that have been
  # heard.
  #
  # options - Hash of options. At least one is required.
  #           :max_words - (Integer) the maximum number of words to be
  #                        generated.
  #
  # Returns a string.
  def spit(options = {})
    unless options[:max_words]
      raise ArgumentError, 'The :max_words option must be provided'
    end

    max_words = Integer(options[:max_words])

    @words_table.keys.first.to_s
  end
end
