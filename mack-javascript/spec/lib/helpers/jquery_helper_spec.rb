require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Mack::JavaScript::Framework::JquerySelector do
  before(:each) do
    Mack::JavaScript::ScriptGenerator.framework = 'jquery'
    @p = Mack::JavaScript::ScriptGenerator.new
  end
  
  it "should handle multiple selector strings" do
    @p.select('.aCon', '.cCon', '.bCon')
    @p.to_s.should == "$('.aCon, .cCon, .bCon');"
  end
  
  it "should chain commands" do
    @p.select('.cCon').children.hide
    @p.to_s.should == "$('.cCon').children().hide();"
  end
  
  it "should translate tree-walking" do
    @p.select('.cCon').ancestors
    @p.to_s.should == "$('.cCon').parents();"
  end

  it "should build tree-walking selectors" do
    @p.select('.cCon').ancestors('#bigWrapper')
    @p.to_s.should == "$('.cCon').parents('#bigWrapper');"
  end
  
  it "should add a class" do
    @p.select('.cCon').add_class('dummy')
    @p.to_s.should == "$('.cCon').addClass('dummy');"
  end
  
  it "should set attributes" do
    @p.select('.cCon').set_attribute('blah', 2)
    @p.to_s.should == "$('.cCon').attr('blah', 2);"
  end
  
  it "should remove attributes" do
    @p.select('.cCon').remove_attribute('blah')
    @p.to_s.should == "$('.cCon').removeAttr('blah');"
  end
    
  it "should insert html" do
    #can insert on top
    @p.select('.cCon').insert(:top, '<p>Top Blah</p>')
    @p.to_s.should == "$('.cCon').prepend('<p>Top Blah<\\/p>');"
    
    # on the bottom
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:bottom, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$('.cCon').append('<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>');"
    
    #before
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:before, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$('.cCon').before('<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>');"
    
    #after
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:after, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$('.cCon').after('<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>');"
  end
  
  it "should replace html" do
    #inner html replacement
    @p.select('.newly_inserted').replace(:inner,"<p>Hazzzaaaahhhh!</p>")
    @p.to_s.should == "$('.newly_inserted').html('<p>Hazzzaaaahhhh!<\\/p>');"
    
    #outer html replacement
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.newly_inserted').replace(:outer, "<div class='newly_inserted'><p>Hashaammm!</p></div>")
    @p.to_s.should == "$('.newly_inserted').replaceWith('<div class=\\'newly_inserted\\'><p>Hashaammm!<\\/p><\\/div>');"
  end
  
  it "should remove html" do
    @p.select('.newly_inserted').remove
    @p.to_s.should == "$('.newly_inserted').remove();"
  end
  
  it "should morph properties" do
    #morph with options
    @p.select('.cCon').morph({:backgroundColor => 'red'}, :duration => 4000)
    @p.to_s.should == "$('.cCon').animate({backgroundColor: 'red'},{duration: 4000});"
    
    #morph without options
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').morph(:backgroundColor => 'white')
    @p.to_s.should == "$('.cCon').animate({backgroundColor: 'white'});"
  end
  
  it "should trigger visual effects" do
    #effect without options
    @p.select('.cCon').effect(:slide_up)
    @p.to_s.should == "$('.cCon').hide('slide',{direction: 'up'});"
    
    #effect with options
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').effect(:drop_in, :duration => 4000, :easing => 'easeOutBounce')
    starter = "$('.cCon').show('drop',{".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["easing: 'easeOutBounce'","direction: 'up'","duration: 4000"].should include(pair.strip)
    end
  end
  
  it "should show selected elements" do
    #plain show
    @p.select('.cCon').show
    @p.to_s.should == "$('.cCon').show();"
    
    #show with fx
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').show(:highlight)
    @p.to_s.should == "$('.cCon').show('highlight');"
    
  end
  
  it "should hide selected elements" do
    @p.select('.cCon').hide(:drop)
    @p.to_s.should == "$('.cCon').hide('drop');"
  end
  
  it "should toggle selected elements" do
    #toggle with fx and options
    @p.select('.cCon').toggle(:drop, :duration => 4000)
    @p.to_s.should == "$('.cCon').toggle('drop',{duration: 4000});"
  end
  
  it "should set event handlers" do
    #event that prevents the default handler
    @p.select('.cCon a').peep 'click', :prevent_default => true do |page|
      page.select('.aCon').effect(:slide_up)
    end
    @p.to_s.should == "$('.cCon a').bind('click', function(event){event.preventDefault();$('.aCon').hide('slide',{direction: 'up'});});"
    
    #event that doesn't prevent the default handler
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon a').peep 'click' do |page|
      page.select('.aCon').effect(:slide_up)
    end
    @p.to_s.should == "$('.cCon a').bind('click', function(event){$('.aCon').hide('slide',{direction: 'up'});});"
  end
  
  it "should remove event handlers" do
    @p.select('.cCon a').stop_peeping 'click'
    @p.to_s.should == "$('.cCon a').unbind('click');"
  end
  
  
  it "should trigger events" do
    @p.select('.bCon .channel').trigger 'mouseover'
    @p.to_s.should == "$('.bCon .channel').trigger('mouseover');"
  end
  
  it "should make elements draggable" do
    @p.select('.cCon').draggable(:revert => 'invalid')
    @p.to_s.should == "$('.cCon').draggable({revert: 'invalid'});"
  end
  
  
  it "should make elements droppable" do
    options = {:accept => '.cCon', :remote => {:url => '/stuff'}}
    @p.select('.aCon').droppable options do |p|
      p.select('.bCon').effect(:highlight)
    end
    starter = "$('.aCon').droppable({drop: function(ev, ui){$.ajax({".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});$('.bCon').show('highlight');},accept: '.cCon'});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["async:true", "data:'id=' + $(ui.draggable).attr('id')", "dataType:'script'", "type:'post'", "url:'/stuff'"].should include(pair.strip)
    end
  end
      
end

describe 'Deprecated Jquery methods' do
  before(:each) do
    Mack::JavaScript::ScriptGenerator.framework = 'jquery'
    @p = Mack::JavaScript::ScriptGenerator.new
  end
  
  it "should translate tbe deprecated 'page.remote_function' to 'page.ajax'" do
    @p.remote_function(:url => '/stuff', :method => :put)
    starter = "$.ajax({".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["async:true", "data:'_method=put'", "dataType:'script'", "type:'post'", "url:'/stuff'"].should include(pair.strip)
    end
  end
  
  it "should translate the deprecated 'page.insert_html' to selector equivalent" do
    @p.insert_html(:top, 'channelList', "<div id='newly_inserted'><p>Yowza</p></div>")
    @p.to_s.should == "$('#channelList').prepend('<div id=\\'newly_inserted\\'><p>Yowza<\\/p><\\/div>');"
  end
  
  it "should translate the deprecated 'page.replace_html' to selector equivalent" do
    @p.replace_html('newly_inserted', "<p>Shazzam</p>")
    @p.to_s.should == "$('#newly_inserted').html('<p>Shazzam<\\/p>');"
  end
  
  it "should translate the deprecated 'page.replace' to selector equivalent" do
    @p.replace('newly_inserted', "<div id='newly_inserted'><p>Bladow</p></div>")
    @p.to_s.should == "$('#newly_inserted').replaceWith('<div id=\\'newly_inserted\\'><p>Bladow<\\/p><\\/div>');"
  end
  
  it "should translate the deprecated 'page.remove' to selector equivalent" do
    #single id
    @p.remove('newly_inserted')
    @p.to_s.should == "$('#newly_inserted').remove();"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.remove('newly_inserted', 'newly_inserted2')
    @p.to_s.should == "$('#newly_inserted, #newly_inserted2').remove();"
  end
  
  it "should translate the deprecated 'page.show' to selector equivalent" do
    #single id
    @p.show('channelList')
    @p.to_s.should == "$('#channelList').show();"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.show('channelList', 'searchResults')
    @p.to_s.should == "$('#channelList, #searchResults').show();"
  end
  
  it "should translate the deprecated 'page.hide' to selector equivalent" do
    #single id
    @p.hide('channelList')
    @p.to_s.should == "$('#channelList').hide();"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.hide('channelList', 'searchResults')
    @p.to_s.should == "$('#channelList, #searchResults').hide();"
  end
  
  it "should translate the deprecated 'page.toggle' to selector equivalent" do
    #single id
    @p.toggle('channelList')
    @p.to_s.should == "$('#channelList').toggle();"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.toggle('channelList', 'searchResults')
    @p.to_s.should == "$('#channelList, #searchResults').toggle();"
  end
  
end



