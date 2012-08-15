Custom Timestamps for ActiveRecord 3.x/4.x and Rails 3.x/4.x
=====

Provide a legacy database, you may need to use columns other than created_at/created_on and updated_at/updated_on.

It does not change "timestamps" behavior in migrations. New models will continue to get updated_at/created_at or whatever you have designated, nor should it affect existing behavior in Rails (ActiveRecord::Timestamp) that looks for created_at/created_on and updated_at/updated_on and updates those on create/update.

It uses the Rails 3.0-4.0 self.record_timestamps to determine if it should update the date of the created_timestamp column(s) and should_record_timestamps? to determine if it should update the date of the updated_timestamp column(s) and it does these in the private create and update methods that then call super to execute the default ActiveRecord::Timestamp defined create and update methods.

### Setup

In your Rails 3+ project, add this to your Gemfile:

    gem 'custom_timestamps', :git => 'git://github.com/garysweaver/custom_timestamps.git'

Then run:

    bundle install

To stay up-to-date, periodically run:

    bundle update custom_timestamps

### Configuration

Custom Timestamps lets you do the following in your model to specify which columns should be used for created_at and updated_at:

    self.created_timestamp :your_created_at_or_created_on_column
    self.updated_timestamp :your_updated_at_or_updated_on_column

It also supports updating multiple columns.

    self.created_timestamp [:column1, :column2]
    self.updated_timestamp [:column3, :column4]

Note: do not specify updated_at or updated_on in self.updated_at nor created_at or created_on in self.created_at as they are already updated by ActiveRecord, created_at, or created_on)

### Usage

Just try to save and update an existing model that has the custom timestamp columns.

### License

Copyright (c) 2012 Gary S. Weaver, released under the [MIT license][lic].

[lic]: http://github.com/garysweaver/custom_timestamps/blob/master/LICENSE
