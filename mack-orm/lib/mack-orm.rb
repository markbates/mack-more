require 'rubygems'
require 'genosaurus'
require 'configatron'

configatron.mack.set_default(:disable_transactional_tests, false)

base = File.join(File.dirname(__FILE__), "mack-orm")
require File.join(base, "database")
require File.join(base, "database_migrations")
require File.join(base, "generators")
require File.join(base, "genosaurus_helpers")
require File.join(base, "model_column")
require File.join(base, "test_extensions")
require File.join(base, "scaffold_generator", "scaffold_generator")

Mack::Environment.after_class_method(:load) do
  Mack::Database.establish_connection(Mack.env)
end

Mack::Portlet::Unpacker.registered_items[:migrations] = Proc.new do |force|
  local_files = Dir.glob(Mack::Paths.migrations('**/*')).sort
  num = '001'
  unless local_files.empty?
    num = File.basename(local_files.last).match(/(\d+)_.+/).captures.first
  end
  files = []
  Mack.search_path(:db, false).each do |path|
    files << Dir.glob(File.join(path, 'migrations', '**/*'))
  end
  files = files.flatten.compact.uniq.sort
  files.each do |f|
    fname = File.basename(f)
    base = fname.match(/\d+_(.+)/).captures.first
    if local_files.include?(/\d+_#{base}/) && !force
      puts "Skipping: #{f}"
    elsif local_files.include?(/\d+_#{base}/) && force
      local_files.each do |lf|
        if lf.match(/\d+_#{base}/)
          puts "Overwriting: #{lf}"
          File.open(lf, 'w') do |w|
            w.puts File.read(f)
          end
          break
        end
      end
    else
      puts "Copying: #{f}"
      num = num.succ
      FileUtils.cp(f, Mack::Paths.migrations("#{num}_#{base}"))
    end
  end
end