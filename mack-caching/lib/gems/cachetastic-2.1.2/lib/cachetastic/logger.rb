# This class handles logging for the caches and their adapters.
class Cachetastic::Logger
  
  # attr_accessor :options
  # attr_accessor :cache_name
  attr_accessor :loggers
  
  def initialize(loggers)
    @loggers = [loggers].flatten
    # self.options = options
    # self.cache_name = cache_name
    # self.options.each_pair do |n, opts|
    #   opts["level"] = (opts["level"] ||= "info").to_sym
    # end
  end
  
  LOG_LEVELS = [:fatal, :error, :warn, :info, :debug]
  
  LOG_LEVELS.each do |level|
    define_method(level) do |*args|
      lm = "[CACHE] [#{level.to_s.upcase}]\t#{Time.now.strftime("%m/%d/%y %H:%M:%S")}"
      exs = []
      args.each do |arg|
        if arg.is_a?(Exception)
          exs << arg
          continue
        end
        lm << "\t" << arg.to_s 
      end
      exs.each do |ex|
        lm << "\n#{ex.message}\n" << ex.backtrace.join("\n")
      end
      self.loggers.each do |log|
        log.send(level, lm)
      end
      # self.options.each_pair do |n, opts|
      #   if LOG_LEVELS.index(opts["level"]) >= LOG_LEVELS.index(level)
      #     case opts["type"]
      #     when "file"
      #       File.open(opts["file"], "a") {|f| f.puts(lm)} 
      #     when "console"
      #       puts lm
      #     end
      #   end
      # end
    end
  end
  
end