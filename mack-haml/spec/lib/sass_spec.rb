require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class SassyController
  include Mack::Controller
  
  def hi
    render(:text, '', :layout => false)
  end
  
end

describe 'sass' do
  
  before(:each) do
    FileUtils.rm_rf(Mack::Paths.stylesheets('sassy.css'))
  end
  
  after(:each) do
    FileUtils.rm_rf(Mack::Paths.stylesheets('sassy.css'))
  end
  
  it 'should build a stylesheet dynamically' do
    get '/sassy/hi'
    File.should be_exist(Mack::Paths.stylesheets('sassy.css'))
    File.read(Mack::Paths.stylesheets('sassy.css')).should == fixture('sassy.css')
  end
  
end