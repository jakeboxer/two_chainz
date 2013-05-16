require 'bundler'
Bundler.setup

####################
# Helper functions #
####################

def gem_name
  @gem_name ||= Dir['*.gemspec'].first.split('.').first
end

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

#########################################
# Open a console preloaded with the gem #
#########################################

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -r ./lib/#{gem_name}.rb"
end

#################
# Build the gem #
#################

gemspec = eval(File.read("#{gem_name}.gemspec"))
task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["#{gem_name}.gemspec"] do
  system "gem build #{gem_name}.gemspec"
  system "gem install #{gem_name}-#{TwoChainz::VERSION}.gem"
end
