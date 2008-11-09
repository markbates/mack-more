Rake::GemPackageTask.new(@gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
  rm_f FileList['pkg/**/*.*']
  rm_f FileList['doc/**/*.*']
end

namespace :gem do
  
  namespace :package  do
    
    task :freezer do
      require 'gemfreezer'
      GemFreezer.run(GemFreezer::Options.new(:freeze_directory => File.join(FileUtils.pwd, 'lib', 'gems')))
    end
    
  end
  
end