require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

# Override the default task
task :default => [] # Just in case it hasn't already been set
Rake::Task[:default].clear
task :default => :appraise

task :appraise do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    load 'test/custom_timestamps_test.rb'
  else
    exec 'rake appraisal:install && rake appraisal'
  end
end
