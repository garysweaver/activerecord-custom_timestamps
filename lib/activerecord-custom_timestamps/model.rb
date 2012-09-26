require 'activerecord-custom_timestamps/config'

module CustomTimestamps
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :created_timestamp, instance_writer: false
      class_attribute :updated_timestamp, instance_writer: false
      class_attribute :update_custom_updated_timestamp_on_create, instance_writer: false
      puts "now module.object_id=#{CustomTimestamps.object_id} && module.update_custom_updated_timestamp_on_create?=#{CustomTimestamps.update_custom_updated_timestamp_on_create?}"
      self.update_custom_updated_timestamp_on_create = CustomTimestamps.update_custom_updated_timestamp_on_create?
    end

  private

    def create
      puts "create called. self.created_timestamp=#{self.created_timestamp} && self.record_timestamps=#{self.record_timestamps}"
      if self.record_timestamps
        current_time = current_time_from_proper_timezone
        if self.created_timestamp
          Array.wrap(self.created_timestamp).each do |column|
            if respond_to?(column) && respond_to?("#{column}=") && self.send(column).nil?
              write_attribute(column.to_s, current_time)
            end
          end
        end

        puts "self.update_custom_updated_timestamp_on_create?=#{self.update_custom_updated_timestamp_on_create?} self.record_timestamps=#{self.record_timestamps} self.updated_timestamp=#{self.updated_timestamp}"
        if self.updated_timestamp && self.update_custom_updated_timestamp_on_create?
          puts "going to write to self.updated_timestamp=#{self.updated_timestamp}"
          Array.wrap(self.updated_timestamp).each do |column|
            if respond_to?(column) && respond_to?("#{column}=") && self.send(column).nil?
              puts "writing updated time #{current_time} to #{column.to_s}"
              write_attribute(column.to_s, current_time)
            end
          end
        end
      end

      super
    end

    def update(*args)
      puts "update called"
      # should_record_timestamps? checks for changes, i.e. self.record_timestamps && (!partial_updates? || changed? || (attributes.keys & self.class.serialized_attributes.keys).present?)
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
