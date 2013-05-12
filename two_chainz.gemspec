require File.expand_path('../lib/two_chainz/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'two_chainz'
  s.version     = TwoChainz::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-05-11'
  s.summary     = 'Generate random sentences with Markov chains'
  s.description = 'Two Chainz is a gem for creating randomly-generated sentences with Markov chains'
  s.authors     = ['Jake Boxer']
  s.email       = 'jake@github.com'
  s.homepage    = 'https://github.com/jakeboxer/two_chainz'

  s.required_rubygems_version = '>= 1.3.6'
  s.required_ruby_version     = '>= 1.9.2'

  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
end
