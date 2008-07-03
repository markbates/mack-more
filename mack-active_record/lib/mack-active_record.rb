require 'rubygems'
require 'genosaurus'

require 'activerecord'

fl = File.join(File.dirname(__FILE__))

require File.join(fl, "database")
require File.join(fl, "helpers", "orm_helpers")
require File.join(fl, "model_column")
require File.join(fl, "genosaurus_helpers")

# [:migration, :model, :scaffold].each do |gen|
#   require File.join(fl, "#{gen}_generator", "#{gen}_generator")
# end
[:helpers, :migration_generator, :model_generator, :scaffold_generator].each do |folder|
  Dir.glob(File.join(File.dirname(__FILE__), folder.to_s, "**/*.rb")).each {|f| require f}
end

ActiveRecord::Base.logger = Mack.logger

Mack::Database.establish_connection(Mack::Configuration.env)