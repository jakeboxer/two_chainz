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

generator.hear("Drop it to the floor, make that ass shake")
generator.hear("Whoa, make the ground move, that's an ass quake")
generator.hear("Built a house up on that ass, that's an ass state")
generator.hear("Roll my weed on it, that's an ass tray")

generator.spit(:words => 6) # => "Built a weed on that ass quake"
```
