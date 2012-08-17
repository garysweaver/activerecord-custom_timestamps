# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
require "activerecord-custom_timestamps/version" 

Gem::Specification.new do |s|
  s.name        = 'activerecord-custom_timestamps'
  s.version     = CustomTimestamps::VERSION
  s.authors     = ['Gary S. Weaver']
  s.email       = ['garysweaver@gmail.com']
  s.homepage    = 'https://github.com/garysweaver/activerecord-custom_timestamps'
  s.summary     = %q{Custom Timestamps for ActiveRecord 3.x/4.x.}
  s.description = %q{Allows sets of custom timestamps for all or some models. Can use different timestamps in migrations.}
  s.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  s.license = 'MIT'
  s.add_dependency 'activerecord'
end
