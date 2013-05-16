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

generator.spit(:max_words => 12) # => "We just as a fuck chain even when I'm in the credit"
```

## Less important shit

If you instantiate the generator normally, spitting will be random.

``` ruby
generator = TwoChainz::Generator.new

generator.hear("I love you I love you")
generator.hear("You are alright I guess")

generator.spit(:max_words => 2) # => "I guess"
generator.spit(:max_words => 2) # => "You I"
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

generator.spit(:max_words => 2) # => "I love"
generator.spit(:max_words => 2) # => "I love"
```
