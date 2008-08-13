require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'find'
require 'rubyforge'
require 'rubygems'
require 'rubygems/gem_runner'
require 'spec'
require 'spec/rake/spectask'
require 'pathname'
require File.join(File.dirname(__FILE__), 'gem_version')

def full_gem_list
  gem_base = File.join(File.dirname(__FILE__), "..")
  gems = Dir.glob(File.join(gem_base, 'mack-*'))
  gems = gems.collect {|g| g.gsub("#{gem_base}/mack-", '')}
  gems.delete("more")
  gems << "more"
  gems.delete("orm")
  gems.insert(0, "orm")
  gems
end

def gem_list_without_more
  fgl = full_gem_list
  fgl.delete("more")
  fgl
end

def gem_list_without_orm_and_more
  fgl = gem_list_without_more
  fgl.delete("orm")
  fgl.delete("active_record")
  fgl.delete("data_mapper")
  fgl
end