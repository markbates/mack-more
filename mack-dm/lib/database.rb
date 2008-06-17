module Mack
  module Database
    def self.establish_connection(env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack::Configuration.root, "config", "database.yml"))).result)
      settings = dbs[env]
      settings.symbolize_keys!
      if settings[:default]
        settings.each do |k,v|
          DataMapper.setup(k, v.symbolize_keys)
        end
      else
        DataMapper.setup(:default, settings)
      end
    end
  end
end