require 'activerecord-custom_timestamps'

module CustomTimestamps
  class Railtie < Rails::Railtie
    initializer "custom_timestamps.active_record" do
      ActiveSupport.on_load(:active_record) do
        include Rails::VERSION::MAJOR > 3 ? ::CustomTimestamps::Model : ::CustomTimestamps::Rails3Model
      end
    end
  end
end
