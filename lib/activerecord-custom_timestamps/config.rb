module CustomTimestamps
  class << self
    attr_accessor :update_custom_updated_timestamp_on_create
    alias_method :update_custom_updated_timestamp_on_create?, :update_custom_updated_timestamp_on_create
  end
end

# defaults
CustomTimestamps.update_custom_updated_timestamp_on_create = true
