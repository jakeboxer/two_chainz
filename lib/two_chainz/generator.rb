class TwoChainz::Generator
  # Pattern used to find URLs in text.
  # Taken from http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without-the
  URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[.\!\/\\w]*))?)/

  # Pattern used to find @mentions in text.
  # Taken from https://github.com/jch/html-pipeline/blob/eb3bcb2a44cf1cbb273efa83ccbdda7972590c1a/lib/html/pipeline/%40mention_filter.rb#L38-L48
  MENTION_REGEX = /
    (?:^|\W)                   # beginning of string or non-word char
    @((?>[\w][\w-]*))  # @username
    (?!\/)                     # without a trailing slash
    (?=
      \.+[ \t\W]|              # dots followed by space or non-word character
      \.+$|                    # dots at end of line
      [^0-9a-zA-Z_.]|          # non-word character except dot
      $                        # end of line
    )
  /ix

  # Words that are not allowed in the table
  WORD_BLACKLIST = [
    ':'
  ]

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
    words         = sanitize(words)
    previous_word = nil

    words.scan(/[\w\':+#]+/) do |current_word|
      # Skip the word if it's in the blacklist
      next if WORD_BLACKLIST.include?(current_word)

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
      target_chars = if @random && (min_chars = options[:min_chars])
        @random.rand(min_chars..max_chars)
      else
        max_chars
      end

      sentence_length = -1 # Start at -1 cuz of the first space

      while sentence_length < target_chars
        previous_word    = sentence.last || :beginning
        word             = word_after(previous_word)
        sentence_length += word.length + 1 # Include space

        sentence << word_after(previous_word) unless sentence_length > target_chars
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
    next_word = nil
    choices   = @words_table.words_after(previous_word)

    if @random
      # Random mode
      next_word = random_word(choices)

      if next_word == :ending
        next_word = random_word(@words_table.words_after(:beginning))
      end
    else
      # Boring mode

      # Pick the most popular next word.
      next_word = choices.max_by {|word, count| count}.first

      # If the most popular next word is the sentence ending, pick the
      # alphabetical first word.
      next_word = @words_table.words.sort.first if next_word == :ending
    end

    next_word
  end

  # Internal: Remove unwanted tokens from the specified text.
  #
  # text - Text to remove unwanted tokens from.
  #
  # NOTE: This should prolly be refactored into a Sanitizer object with options
  # and its own tests and stuff. If this method starts getting big, do that.
  #
  # ANOTHER NOTE: This hurts accuracy a little cuz it glues together two words
  # that did not originally follow each other directly. Might be worth breaking
  # up the string into multiple #hears on removed tokens or some other way of
  # decreasing the importance of a pair made in this way. Honestly though, it
  # probably doesn't matter that much, so don't spend a ton of time on it.
  #
  # Returns a string.
  def sanitize(text)
    sanitized_text = text.dup

    # Strip URLs
    sanitized_text.gsub!(URL_REGEX, '')

    # Strip @mention style tokens
    sanitized_text.gsub!(MENTION_REGEX, '')

    sanitized_text
  end

  # Internal: Pick a word randomly (weighted) from a hash of words. Each word
  # has a chance of being picked equivalent to current_word_count / total_word_count.
  #
  # words - Hash of words to pick one from. Keys are words, values are counts.
  #
  # Example:
  #
  #   words = {'dog' => 5, 'cat' => 3, 'fish' => 2}
  #   random_word(words)
  #   # => 'cat'
  #   random_word(words)
  #   # => 'dog'
  #
  # Returns a string.
  def random_word(words)
    chosen_word             = nil
    total_occurrences_count = words.values.inject(:+)
    ordered_words           = Array(words).sort {|arr| arr.last }

    ticket    = @random.rand(total_occurrences_count)
    threshold = 0

    ordered_words.each do |(word, count)|
      threshold += count

      if ticket < threshold
        chosen_word = word
        break
      end
    end

    chosen_word
  end
end
