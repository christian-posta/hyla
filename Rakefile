require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'bundler/version'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

#############################################################################
#
# Helper functions
#
#############################################################################
def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def date
  Date.today.to_s
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

#############################################################################
#
# Standard tasks
#
#############################################################################

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

# Simple Test case
task :test do
  ruby "test/my_test.rb"
end

task :build1 do
  system "gem build #{gemspec_file}"
end

# Build project
task :build2 => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end