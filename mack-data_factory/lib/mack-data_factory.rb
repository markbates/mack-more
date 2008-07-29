fl = File.dirname(__FILE__)

require 'faker'

[:data_factory, :field, :field_manager, :content_generator].each do |f|
  require File.join(fl, 'mack-data_factory', "#{f}.rb")
end

[:kernel].each do |f|
  require File.join(fl, 'mack-data_factory', 'core_extensions', "#{f}.rb")
end

[:bridge].each do |f|
  require File.join(fl, 'mack-data_factory', 'orm_api_bridge', "#{f}.rb")
end

[:active_record, :data_mapper, :default].each do |f|
  require File.join(fl, 'mack-data_factory', 'orm_api_bridge', 'orm', "#{f}.rb")
end