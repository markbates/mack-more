desc "Run test code"
Rake::TestTask.new(:default) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
