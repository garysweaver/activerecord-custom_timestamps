Custom Timestamps for ActiveRecord 3.x/4.x and Rails 3.x/4.x
=====

Sometimes you may need to use timestamp columns other than created_at/created_on and updated_at/updated_on, e.g. when you are using a legacy database. Custom Timestamps lets you define one or more additional columns to update just like Rails updates created_at/created_on and/or updated_at/updated_on.

This does not change "timestamps" behavior in migrations. New models will continue to get updated_at/created_at or whatever you have designated, nor should it affect existing behavior in Rails (ActiveRecord::Timestamp) that looks for created_at/created_on and updated_at/updated_on and updates those on create/update.

It uses the Rails/ActiveRecord 3.x-4.x self.record_timestamps to determine if it should update the date of the created_timestamp column(s) and should_record_timestamps? to determine if it should update the date of the updated_timestamp column(s) and it does these in the private create and update methods that then call super to execute the default ActiveRecord::Timestamp defined create and update methods.

### Setup

In your ActiveRecord/Rails 3.1+ project, add this to your Gemfile:

    gem 'activerecord-custom_timestamps'

Then run:

    bundle install

### Configuration

#### In Model

Custom Timestamps lets you do the following in your model to specify which columns should be used for created_at and updated_at:

    self.created_timestamp = :manufactured_on
    self.updated_timestamp = :modded_on

It also supports updating multiple columns.

    self.created_timestamp = [:manufactured_on, :amalgamated_at]
    self.updated_timestamp = [:redesigned_at, :redesign_release_date]

You don't need to specify updated_at or updated_on in self.updated_at, and you don't need to specify created_at or created_on in self.created_at. Those columns are still updated by ActiveRecord (unless you overrode that).

If you want to control whether your custom self.updated_timestamp column(s) will be updated on create also, and don't want to set that as an application-wide default or use the default, then:

    self.update_custom_updated_timestamp_on_create = false # default is true

#### In Application

In environment.rb or wherever seems most appropriate, you can set the configuration option in one of two ways:

    CustomTimestamps.update_custom_updated_timestamp_on_create = false # default is true

Please set this one to either true or false to avoid issues if defaults change later.

### Usage

Just try to save and update an existing model that has the custom timestamp columns.

## Authors

This app was written by [FineLine Prototyping, Inc.](http://www.finelineprototyping.com) by the following contributors:
* Gary Weaver (https://github.com/garysweaver)

### License

Copyright (c) 2013 FineLine Prototyping, Inc., released under the [MIT license][lic].

[lic]: http://github.com/FineLinePrototyping/activerecord-custom_timestamps/blob/master/LICENSE
