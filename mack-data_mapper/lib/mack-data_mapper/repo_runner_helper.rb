module Mack
  module DataMapper # :nodoc:
    # This runner helper will wrap a request with a DataMapper::Repository.
    # To turn on this runner set the following configuration value equal to true:
    #   configatron.mack.data_mapper.use_repository_runner = true
    # To set the context in which the runner helper runs, set this configuration value:
    #   configatron.mack.data_mapper.repository_runner_context = :default
    class RepositoryRunnerHelper < Mack::RunnerHelpers::Base
      
      def start(request, response, cookies)
        ::DataMapper::Repository.context << ::DataMapper::Repository.new(configatron.mack.data_mapper.repository_runner_context)
      end
      
      def complete(request, response, cookies)
        ::DataMapper::Repository.context.pop
      end
      
    end
  end
end

Mack::RunnerHelpers::Registry.add(Mack::DataMapper::RepositoryRunnerHelper) if configatron.mack.data_mapper.use_repository_runner