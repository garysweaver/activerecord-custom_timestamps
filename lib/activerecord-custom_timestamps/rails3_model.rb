require 'activerecord-custom_timestamps/config'

module CustomTimestamps
  module Rails3Model
    extend ActiveSupport::Concern

    included do
      class_attribute :created_timestamp, instance_writer: false
      class_attribute :updated_timestamp, instance_writer: false
      class_attribute :update_custom_updated_timestamp_on_create, instance_writer: false
      self.update_custom_updated_timestamp_on_create = CustomTimestamps.update_custom_updated_timestamp_on_create?
    end

  private

    def create
      if self.record_timestamps
        current_time = current_time_from_proper_timezone
        
        Array.wrap(self.created_timestamp).each do |column|
          if respond_to?(column) && respond_to?("#{column}=") && self.send(column).nil?
            write_attribute(column.to_s, current_time)
          end
        end

        if self.update_custom_updated_timestamp_on_create
          Array.wrap(self.updated_timestamp).each do |column|
            column = column.to_s
            next if attribute_changed?(column)
            write_attribute(column, current_time)
          end
        end
      end

      super
    end

    def update(*args)
      if should_record_timestamps?
        current_time = current_time_from_proper_timezone

        Array.wrap(self.updated_timestamp).each do |column|
          column = column.to_s
          next if attribute_changed?(column)
          write_attribute(column, current_time)
        end
      end
      super
    end
  end
end
