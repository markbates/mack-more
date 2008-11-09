puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

configatron.mack.set_default(:disable_transactional_tests, false)
configatron.mack.database.pagination.set_default(:results_per_page, 10)

base = File.join(File.dirname(__FILE__), "mack-orm")
require File.join(base, "database")
require File.join(base, "database_migrations")
require File.join(base, "generators")
require File.join(base, "genosaurus_helpers")
require File.join(base, "model_column")
require File.join(base, "test_extensions")
require File.join(base, "paginator")
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
      puts "Skipping: #{base}"
    elsif local_files.include?(/\d+_#{base}/) && force
      local_files.each do |lf|
        if lf.match(/\d+_#{base}/)
          n = lf.match(/(\d+)_#{base}/).captures.first
          puts "Overwriting: #{base}"
          src = File.read(f)
          src.scan(/migration\D+\d+/).each do |line|
            src.gsub!(line, line.gsub(/\d+/, n))
          end
          File.open(lf, 'w') do |w|
            w.puts src
          end
          break
        end
      end
    else
      puts "Creating: #{"#{num}_#{base}"}"
      num = num.succ
      src = File.read(f)
      src.scan(/migration\D+\d+/).each do |line|
        src.gsub!(line, line.gsub(/\d+/, num))
      end
      File.open(Mack::Paths.migrations("#{num}_#{base}"), 'w') do |w|
        w.puts src
      end # File.open
    end # if
  end # files.each
end # Proc