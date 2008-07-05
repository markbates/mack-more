module Mack
  module Database
    def self.establish_connection(env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      ActiveRecord::Base.establish_connection(dbs[env])
    end
  end
end