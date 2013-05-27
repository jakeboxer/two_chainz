# Two Chainz

> She got a big booty so I call her Big Booty  
> Scrr... scrr... wrists moving, cooking, getting to it  
> I'm in the kitchen, yams everywhere  
> Just made a jug, I got bands everywhere  
>   
– [2 Chainz - Birthday Song](http://rapgenius.com/2-chainz-birthday-song-lyrics) (which was generated entirely with this gem)

**Two Chainz** is a Ruby gem for generating random sentences with [Markov chains](http://en.wikipedia.org/wiki/Markov_chain).

## Quickstart

``` ruby
require 'two_chainz'

generator = TwoChainz::Generator.new

generator.hear("We just want the credit where it's due")
generator.hear("Imma worry bout me, give a fuck about you")
generator.hear("Just as a reminder to myself")
generator.hear("I wear every single chain even when I'm in the house")

generator.spit(:words => 12) # => "We just as a fuck chain even when I'm in the credit"
```

## Less important shit

If you instantiate the generator normally, spitting will be random.

``` ruby
generator = TwoChainz::Generator.new

generator.hear("I love you I love you")
generator.hear("You are alright I guess")

generator.spit(:words => 2) # => "I guess"
generator.spit(:words => 2) # => "You I"
```

You can seed the generator if you want consistency.

``` ruby
generator = TwoChainz::Generator.new(:seed => 3)
```

If you want even more consistency, run it in boring mode. This will always continue the chain the same way: the most common next word is picked every time, and the alphabetically-first word is picked if there's a tie.

``` ruby
generator = TwoChainz::Generator.new(:boring => true)

generator.hear("I love you I love you I love you")
generator.hear("You are alright I guess")

generator.spit(:words => 2) # => "I love"
generator.spit(:words => 2) # => "I love"
```

Instead of specifying how many words you want, you can specify a maximum number of characters. You'll get a sentence that is guaranteed to be that many characters or fewer (and it will usually come pretty close).

``` ruby
generator = TwoChainz::Generator.new

generator.hear("Once they caught us off-guard")
generator.hear("The Mac-10 was in the grass and")
generator.hear("I ran like a cheetah with thoughts of an assassin")

generator.spit(:max_chars => 20) # => "Once they cheetah"
```

If you use `:max_chars`, you can also optionally use `:min_chars`. If you do, the spit will aim for some point in between the max and min.

``` ruby
generator.spit(:max_chars => 20, :min_chars => 10) # => "Once they caught"
```
