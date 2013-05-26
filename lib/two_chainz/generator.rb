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
    @words_table = TwoChainz::WordsTable.new

    unless options[:boring]
      seed    = options[:seed]
      @random = seed ? Random.new(seed) : Random.new
    end
  end

  # Public: Hear some words and remember them for future spitting.
  #
  # words - String of words to hear.
  #
  # Returns nothing.
  def hear(words)
    previous_word = nil

    words.scan(/[\w\'@]+/) do |current_word|
      # Increment the number of times the current word has been the successor of
      # the previous word.
      @words_table.increment(previous_word, current_word)

      previous_word = current_word
    end

    # Record what the last word was.
    @words_table.increment(previous_word) if previous_word

    true
  end

  # Public: Produce a randomized sentence based on the words that have been
  # heard.
  #
  # options - Hash of options. At least one is required.
  #           :words - (Integer) the number of words to be generated.
  #           :max_chars - (Integer) the maximum number of characters to be
  #                        generated.
  #
  # Returns a string.
  def spit(options = {})
    if @words_table.words.empty?
      raise StandardError, "The generator hasn't heard anything yet"
    end

    words     = options[:words] && Integer(options[:words])
    max_chars = options[:max_chars] && Integer(options[:max_chars])

    sentence = []

    if words
      words.times do |i|
        previous_word = sentence.last || :beginning
        sentence << word_after(previous_word)
      end
    elsif max_chars
      sentence_length = -1 # Start at -1 cuz of the first space

      while sentence_length < max_chars
        previous_word    = sentence.last || :beginning
        word             = word_after(previous_word)
        sentence_length += word.length + 1 # Include space

        sentence << word_after(previous_word) unless sentence_length > max_chars
      end
    else
      raise ArgumentError, "Either :words or :max_chars must be specified"
    end

    sentence.join(' ')
  end

  private

  # Internal: Get a word that comes after the specified one.
  #
  # previous_word - The word that will be coming before whichever one we pick.
  #
  # Returns a string.
  def word_after(previous_word)
    choices = @words_table.words_after(previous_word)

    # Pick the most popular next word.
    # TODO(jakeboxer): Make this random in non-boring situations.
    next_word = choices.max_by {|word, count| count}.first

    # If the most popular next word is the sentence ending, pick the
    # alphabetical first word.
    # TODO(jakeboxer): Make this random in non-boring situations.
    next_word = heard_words.sort.first if next_word == :ending

    next_word
  end
end
