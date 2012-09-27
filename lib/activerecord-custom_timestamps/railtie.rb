require 'activerecord-custom_timestamps'

module CustomTimestamps
  class Railtie < Rails::Railtie
    initializer "custom_timestamps.active_record" do
      ActiveSupport.on_load(:active_record) do
        include CustomTimestamps::Model
      end
    end
  end
end
