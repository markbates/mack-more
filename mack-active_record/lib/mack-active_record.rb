puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

# require 'rubygems'
require 'genosaurus'
require 'mack-orm'
require 'activerecord'

module ActiveRecord # :nodoc:
end

fl = File.join(File.dirname(__FILE__), "mack-active_record")

require File.join(fl, "database")
require File.join(fl, "database_migrations")
require File.join(fl, "generators")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "test_extensions")

# [:migration, :model, :scaffold].each do |gen|
#   require File.join(fl, "#{gen}_generator", "#{gen}_generator")
# end
[:helpers, :migration_generator, :model_generator, :scaffold_generator].each do |folder|
  Dir.glob(File.join(fl, folder.to_s, "**/*.rb")).each {|f| require f}
end

ActiveRecord::Base.logger = Mack.logger

Mack::Database.establish_connection(Mack.env)