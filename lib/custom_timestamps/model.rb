module CustomTimestamps
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :created_timestamp, instance_writer: false
      class_attribute :updated_timestamp, instance_writer: false
    end

  private

    def create
      if self.created_timestamp && self.record_timestamps
        current_time = current_time_from_proper_timezone

        Array.wrap(self.created_timestamp).each do |column|
          if respond_to?(column) && respond_to?("#{column}=") && self.send(column).nil?
            write_attribute(column.to_s, current_time)
          end
        end
      end

      super
    end

    def update(*args)
      # should_record_timestamps? checks for changes
      if self.updated_timestamp && should_record_timestamps?
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
