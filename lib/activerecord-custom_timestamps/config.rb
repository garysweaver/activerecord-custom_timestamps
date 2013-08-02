module CustomTimestamps
  class << self
    attr_accessor :update_custom_updated_timestamp_on_create
    def update_custom_updated_timestamp_on_create?
      !!update_custom_updated_timestamp_on_create
    end
  end
end

# defaults
CustomTimestamps.update_custom_updated_timestamp_on_create = true
