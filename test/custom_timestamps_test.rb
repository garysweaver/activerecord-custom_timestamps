require 'test/unit'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + "/../lib/activerecord-custom_timestamps")

DB_FILE = 'tmp/test_db'

FileUtils.mkdir_p File.dirname DB_FILE
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_FILE

ActiveRecord::Base.connection.execute 'CREATE TABLE plain_models (id INTEGER NOT NULL PRIMARY KEY, my_notes VARCHAR(32))'
ActiveRecord::Base.connection.execute 'CREATE TABLE no_customization_models (id INTEGER NOT NULL PRIMARY KEY, my_notes VARCHAR(32))'
ActiveRecord::Base.connection.execute 'CREATE TABLE foobars (id INTEGER NOT NULL PRIMARY KEY, my_number INTEGER, manufactured_on DATE, other_on DATE, modded_on DATE)'
ActiveRecord::Base.connection.execute 'CREATE TABLE barfoos (id INTEGER NOT NULL PRIMARY KEY, my_notes VARCHAR(32), manufactured_on DATE, amalgamated_at DATETIME, redesigned_at DATETIME, redesign_release_date DATE, other_at DATETIME)'

class CustomTimestampsTest < Test::Unit::TestCase

  def setup
    ActiveRecord::Base.connection.execute 'DELETE FROM plain_models'
    ActiveRecord::Base.connection.execute 'DELETE FROM no_customization_models'
    ActiveRecord::Base.connection.execute 'DELETE FROM foobars'
    ActiveRecord::Base.connection.execute 'DELETE FROM barfoos'
  end

  # plain/unaltered

  def test_plain_model_can_create
    m = PlainModel.new
    refute m.respond_to?(:created_timestamp)
    refute m.respond_to?(:updated_timestamp)
    m.my_notes = 'abc'
    m.save!
    assert_equal 'abc', PlainModel.where(id: m.id).first.my_notes
  end

  def test_plain_model_can_update
    m = PlainModel.new
    refute m.respond_to?(:created_timestamp)
    refute m.respond_to?(:updated_timestamp)
    m.my_notes = 'abc'
    m.save!
    m.my_notes = 'def'
    m.save!
    assert_equal 'def', PlainModel.where(id: m.id).first.my_notes
  end

  # include only

  def test_no_customization_model_can_create
    m = NoCustomizationModel.new
    assert m.respond_to?(:created_timestamp)
    assert m.respond_to?(:updated_timestamp)
    m.my_notes = 'abc'
    m.save!
    assert_equal 'abc', NoCustomizationModel.where(id: m.id).first.my_notes
  end

  def test_no_customization_model_can_update
    m = NoCustomizationModel.new
    assert m.respond_to?(:created_timestamp)
    assert m.respond_to?(:updated_timestamp)
    m.my_notes = 'abc'
    m.save!
    m = NoCustomizationModel.where(id: m.id).first
    assert_equal 'abc', m.my_notes
    m.my_notes = 'def'
    m.save!
    # save after retrieval
    assert_equal 'def', NoCustomizationModel.where(id: m.id).first.my_notes
    m.my_notes = 'ghi'
    m.save!
    # save without re-retrieval
    assert_equal 'ghi', NoCustomizationModel.where(id: m.id).first.my_notes
  end

  # date columns set
  
  def test_single_column_custom_created_timestamp_model_can_create
    m = Foobar.new
    m.my_number = 35
    m.manufactured_on = m.modded_on = nil
    m.save!
    m = Foobar.where(id: m.id).first
    assert m.my_number = 35
    assert m.other_on == nil
    assert m.manufactured_on != nil
    assert m.modded_on != nil
    assert m.manufactured_on == m.modded_on
    assert m.manufactured_on > Date.today - 2
  end

  def test_single_column_custom_created_timestamp_model_can_update
    orig = Foobar.update_custom_updated_timestamp_on_create
    Foobar.update_custom_updated_timestamp_on_create = false
    m = Foobar.new
    m.my_number = 35
    m.save!
    m.my_number = 40
    m.manufactured_on = m.modded_on = nil
    m.save!
    m = Foobar.where(id: m.id).first
    assert m.my_number = 40
    assert m.other_on == nil
    assert m.manufactured_on == nil
    assert m.modded_on != nil
    assert m.modded_on > Date.today - 2
  ensure
    Foobar.update_custom_updated_timestamp_on_create = orig
  end

  def test_single_column_custom_created_timestamp_model_can_update_when_date_fields_changed_in_db
    orig = Foobar.update_custom_updated_timestamp_on_create
    Foobar.update_custom_updated_timestamp_on_create = false
    m = Foobar.new
    m.my_number = 35
    m.save!
    m.my_number = 40
    ActiveRecord::Base.connection.execute "UPDATE foobars SET manufactured_on = NULL, modded_on = null WHERE id = #{m.id}"
    m.save!
    m = Foobar.where(id: m.id).first
    assert m.my_number = 40
    assert m.other_on == nil
    assert m.manufactured_on == nil
    assert m.modded_on != nil
    assert m.modded_on > Date.today - 2
  ensure
    Foobar.update_custom_updated_timestamp_on_create = orig
  end

  def test_single_column_custom_created_timestamp_model_wont_update_if_no_field_changed_and_saved
    orig = Foobar.update_custom_updated_timestamp_on_create
    Foobar.update_custom_updated_timestamp_on_create = false
    m = Foobar.new
    m.my_number = 35
    m.save!
    ActiveRecord::Base.connection.execute "UPDATE foobars SET manufactured_on = NULL, modded_on = null WHERE id = #{m.id}"
    m.save!
    m = Foobar.where(id: m.id).first
    assert m.my_number = 40
    assert m.other_on == nil
    assert m.manufactured_on == nil
    assert m.modded_on == nil
  ensure
    Foobar.update_custom_updated_timestamp_on_create = orig
  end

end

# Helper classes

class PlainModel < ActiveRecord::Base
end

class NoCustomizationModel < ActiveRecord::Base
  include ActiveRecord::VERSION::MAJOR > 3 ? ::CustomTimestamps::Model : ::CustomTimestamps::Rails3Model
end

class Foobar < ActiveRecord::Base
  include ActiveRecord::VERSION::MAJOR > 3 ? ::CustomTimestamps::Model : ::CustomTimestamps::Rails3Model
  self.created_timestamp = :manufactured_on
  self.updated_timestamp = :modded_on
end

class Barfoo < ActiveRecord::Base
  include ActiveRecord::VERSION::MAJOR > 3 ? ::CustomTimestamps::Model : ::CustomTimestamps::Rails3Model
  self.created_timestamp = [:manufactured_on, :amalgamated_at]
  self.updated_timestamp = [:redesigned_at, :redesign_release_date]
end
