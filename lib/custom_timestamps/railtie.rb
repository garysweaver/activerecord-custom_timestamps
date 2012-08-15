require 'custom_timestamps'

module CustomTimestamps
  class Railtie < Rails::Railtie
    initializer "custom_timestamps.active_record" do
      ActiveSupport.on_load(:active_record) do
        # ActiveRecord::Base gets new behavior
        include CustomTimestamps::Model # ActiveSupport::Concern
      end
    end
  end
end
