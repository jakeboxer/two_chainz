require 'bundler'
Bundler.setup

#################
# Run the tests #
#################

desc "Run tests"
task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

#################
# Build the gem #
#################

gemspec = eval(File.read("two_chainz.gemspec"))
task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["two_chainz.gemspec"] do
  system "gem build two_chainz.gemspec"
  system "gem install two_chainz-#{TwoChainz::VERSION}.gem"
end
