require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

module RenderActionHelper
  def validate_content(file_name)
    body = File.read(File.join(File.dirname(__FILE__), "contents", file_name))
    response.body.should == body
  end
end

describe "render(:action)" do  
  describe "haml" do
    include RenderActionHelper
    
    it "should render with a default layout" do
      get maggie_html_haml_with_layout_url
      validate_content("action_haml_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get maggie_html_haml_with_special_layout_url
      validate_content("action_haml_special_layout.txt")
    end
    
    it "should render with no layout if told to do so" do
      get maggie_html_haml_without_layout_url
      response.body.should == "<div id='name'>Maggie Simpson</div>\n<div id='type'>HTML, HAML</div>\n"
    end
    
    it 'should render with a haml layout' do
      get maggie_html_haml_with_haml_layout_url
      validate_content('action_haml_with_haml_layout.txt')
    end
    
    it 'should render with a global haml layout' do
      get '/users/show'
      validate_content('users_show.txt')
    end

  end # haml
end