require 'rubygems'
require 'genosaurus'

base = File.join(File.dirname(__FILE__), "mack-orm")
require File.join(base, "database")
require File.join(base, "database_migrations")
require File.join(base, "generators")
require File.join(base, "genosaurus_helpers")
require File.join(base, "model_column")
require File.join(base, "scaffold_generator", "scaffold_generator")

Mack::Environment.after_class_method(:load) do
  Mack::Database.establish_connection(Mack.env)
end