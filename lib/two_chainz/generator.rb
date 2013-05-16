class TwoChainz::Generator
  # Public: Create a new TwoChainz::Generator instance.
  #
  # options - Hash of options.
  #           :seed -   (Optional integer) Seed to use when spitting. If nothing
  #                     is provided, Ruby core's Random::new_seed will be used.
  #           :boring - (Optional boolean) Don't do any randomness. Always pick
  #                     the most common thing. Mainly for testing. Defaults to
  #                     false.
  #
  # Returns a TwoChainz::Generator
  def initialize(options={})
    @words_table = {:beginning => Hash.new(0)}

    unless options[:boring]
      @random = seed ? Random.new(seed) : Random.new
    end
  end

  # Public: Hear some words and remember them for future spitting.
  #
  # words - String of words to hear.
  #
  # Returns the number of unique new words the generator heard (integer)
  def hear(words)
    heard_words   = 0
    previous_word = nil

    words.scan(/[\w\']+/) do |current_word|
      # If we haven't heard this word before, increment the newly-heard words
      # count.
      heard_words += 1 unless @words_table.has_key?(current_word)

      # Increment the number of times the current word has been the successor of
      # the previous word. If we have no previous word, we're on the first word.
      @words_table[previous_word || :beginning][current_word] += 1

      # Create a words table entry for the current word
      @words_table[current_word] ||= Hash.new(0)

      previous_word = current_word
    end

    # Record what the last word was.
    @words_table[previous_word][:ending] += 1 if previous_word

    heard_words
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

    sentence = []

    # TODO MAKE THIS A METHOD
    # -1 cuz :beginning
    words_count = @words_table.keys.length - 1

    [max_words, words_count].min.times do |i|
      choices = @words_table[(sentence.last || :beginning)]

      # TODO ALLOW THIS TO BE RANDOM IN NON BORING SITUATIONS
      word = choices.max_by {|word, count| count}.first

      if word == :ending
        break
      else
        sentence << word
      end
    end

    sentence.join(' ')
  end
end
