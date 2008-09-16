Rake::RDocTask.new do |rd|
  rd.main = "README"
  files = Dir.glob("**/*.rb")
  files = files.collect {|f| f unless f.match("test/") || f.match("doc/") || f.match("spec/") }.compact
  files << "README"
  rd.rdoc_files = files
  rd.rdoc_dir = "doc"
  rd.options << "--line-numbers"
  rd.options << "--inline-source"
  rd.title = @gem_spec.name
end

task :clean_rdoc do
  require 'fileutils'
  FileUtils.rm_rf('pkg', :verbose => true)
  FileUtils.rm_rf('doc', :verbose => true)
end