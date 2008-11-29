require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Mack::ViewHelpers::HtmlHelpers do
  include Mack::ViewHelpers
  
  describe 'jQuery' do
    
    before(:each) do
      Mack::JavaScript::ScriptGenerator.framework = 'jquery'
    end
    
    describe 'button_to_remote' do
    
      it 'should create a button that does a remote post' do
        configatron.temp do
          configatron.mack.js_framework = 'jquery'
          button_to_remote('Create', :url => '/foo').should == %{<button onclick="$.ajax({async:true, data:$.param($(this.form).serializeArray()), dataType:'script', type:'post', url:'/foo'}); return false" type="submit">Create</button>}
        end
      end
      
    end
    
  end
  
  describe 'Prototype' do
    
    before(:each) do
      Mack::JavaScript::ScriptGenerator.framework = 'prototype'
    end
    
    describe 'button_to_remote' do
      
      it 'should create a button that does a remote post' do
        configatron.temp do
          configatron.mack.js_framework = 'prototype'
          button_to_remote('Create', :url => '/foo').should == %{<button onclick="new Ajax.Request('/foo', {asynchronous:true, evalScripts:true, parameters:Form.serialize(this.form)}); return false" type="submit">Create</button>}
        end
      end
      
    end
    
  end

end