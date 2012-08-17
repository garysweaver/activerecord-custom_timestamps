require 'activerecord-custom_timestamps/version'
require 'activerecord-custom_timestamps/model'
require 'activerecord-custom_timestamps/railtie' if defined?(Rails)

puts "CustomTimestamps #{CustomTimestamps::VERSION}"
