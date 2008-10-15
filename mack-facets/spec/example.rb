run_once do
  File.open(File.join(File.dirname(__FILE__), 'foo.tmp'), 'w') {|f| f.puts 'hello'}
end