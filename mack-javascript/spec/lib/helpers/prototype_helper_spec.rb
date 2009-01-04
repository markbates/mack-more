require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Mack::JavaScript::Framework::PrototypeSelector do
  before(:each) do
    Mack::JavaScript::ScriptGenerator.framework = 'prototype'
    @p = Mack::JavaScript::ScriptGenerator.new
  end
  
  it "should handle multiple selector strings" do
    @p.select('.aCon', '.cCon', '.bCon')
    @p.to_s.should == "$$('.aCon','.cCon','.bCon');"
  end
  
  it "should chain commands" do
    @p.select('.cCon').children.hide
    @p.to_s.should == "$$('.cCon').invoke('childElements').flatten().uniq().invoke('hide');"
  end
  
  it "should translate tree-walking" do
    @p.select('.cCon').ancestors
    @p.to_s.should == "$$('.cCon').invoke('ancestors').flatten().uniq();"
  end

  it "should build tree-walking selectors" do
    @p.select('.cCon').siblings('.aCon')
    @p.to_s.should == "$$('.cCon').invoke('siblings','.aCon').flatten().uniq();"
  end
  
  it "should add a class" do
    @p.select('.cCon').add_class('dummy')
    @p.to_s.should == "$$('.cCon').invoke('addClassName','dummy');"
  end
  
  it "should remove a class" do
    @p.select('.cCon').remove_class('dummy')
    @p.to_s.should == "$$('.cCon').invoke('removeClassName','dummy');"
  end
  
  it "should set attributes" do
    @p.select('.cCon').set_attribute('blah', 2)
    @p.to_s.should == "$$('.cCon').invoke('writeAttribute','blah',2);"
  end
  
  it "should remove attributes" do
    @p.select('.cCon').remove_attribute('blah')
    @p.to_s.should == "$$('.cCon').invoke('writeAttribute','blah',null);"
  end
    
  it "should insert html" do
    #can insert on top
    @p.select('.cCon').insert(:top, '<p>Top Blah</p>')
    @p.to_s.should == "$$('.cCon').invoke('insert',{top: '<p>Top Blah<\\/p>'});"
    
    # on the bottom
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:bottom, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$$('.cCon').invoke('insert',{bottom: '<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>'});"
    
    #before
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:before, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$$('.cCon').invoke('insert',{before: '<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>'});"
    
    #after
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').insert(:after, "<div class='newly_inserted'>\n	<p>Huzzah!</p>\n</div>")
    @p.to_s.should == "$$('.cCon').invoke('insert',{after: '<div class=\\'newly_inserted\\'>\\n	<p>Huzzah!<\\/p>\\n<\\/div>'});"
  end
  
  it "should replace html" do
    #inner html replacement
    @p.select('.newly_inserted').replace(:inner,"<p>Hazzzaaaahhhh!</p>")
    @p.to_s.should == "$$('.newly_inserted').invoke('update','<p>Hazzzaaaahhhh!<\\/p>');"
    
    #outer html replacement
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.newly_inserted').replace(:outer, "<div class='newly_inserted'><p>Hashaammm!</p></div>")
    @p.to_s.should == "$$('.newly_inserted').invoke('replace','<div class=\\'newly_inserted\\'><p>Hashaammm!<\\/p><\\/div>');"
  end
  
  it "should remove html" do
    @p.select('.newly_inserted').remove
    @p.to_s.should == "$$('.newly_inserted').invoke('remove');"
  end
  
  it "should morph properties" do
    #morph with options
    @p.select('.cCon').morph({:backgroundColor => '#f00'}, :duration => 4000)
    @p.to_s.should == "$$('.cCon').invoke('morph',{backgroundColor: '#f00'},{duration: 4.0});"
    
    #morph without options
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').morph(:backgroundColor => '#fff')
    @p.to_s.should == "$$('.cCon').invoke('morph',{backgroundColor: '#fff'});"
  end
  
  
  it "should trigger visual effects" do
    #effect without options
    @p.select('.cCon').effect(:slideUp)
    @p.to_s.should == "$$('.cCon').invoke('visualEffect','slideUp');"
    
    #effect with options
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon').effect(:blindDown, :duration => 4000, :easing => 'spring')
    starter = "$$('.cCon').invoke('visualEffect','blindDown',{".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["transition: function(){return Effect.Transitions.spring}()",
       "duration: 4.0"].should include(pair)
    end
  end
  
  it "should show selected elements" do
    #plain show
    @p.select('.cCon').show
    @p.to_s.should == "$$('.cCon').invoke('show');"
  end
  
  it "should hide selected elements" do
    @p.select('.cCon').hide
    @p.to_s.should == "$$('.cCon').invoke('hide');"
  end
  
  it "should toggle selected elements" do
    #toggle with fx and options
    @p.select('.cCon').toggle
    @p.to_s.should == "$$('.cCon').invoke('toggle');"
  end
  
  it "should set event handlers" do
    #event that prevents the default handler
    @p.select('.cCon a').peep 'click', :prevent_default => true do |page|
      page.select('.aCon').effect(:slideUp)
    end
    @p.to_s.should == "$$('.cCon a').invoke('observe','click',function(event){event.stop();$$('.aCon').invoke('visualEffect','slideUp');});"
    
    #event that doesn't prevent the default handler
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.select('.cCon a').peep 'click' do |page|
      page.select('.aCon').effect(:slideUp)
    end
    @p.to_s.should == "$$('.cCon a').invoke('observe','click',function(event){$$('.aCon').invoke('visualEffect','slideUp');});"
  end
  
  it "should remove event handlers" do
    @p.select('.cCon a').stop_peeping 'click'
    @p.to_s.should == "$$('.cCon a').invoke('stopObserving','click');"
  end
  
  
  it "should trigger events" do
    @p.select('.bCon .channel').trigger 'mouseover'
    @p.to_s.should == "$$('.bCon .channel').invoke('fire','mouseover');"
  end
  
  it "should make elements draggable" do
    @p.select('.cCon').draggable(:revert => false, :ghosting => true)    
    starter = "$$('.cCon').each(function(elem){new Draggable(elem, {".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "})});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["ghosting: true","revert: false"].should include(pair)
    end
  end
  
  
  it "should make elements droppable" do
    options = {:remote => {:url => '/stuff'}}
    @p.select('.aCon').droppable options do |p|
      p.select('.bCon').effect(:highlight)
    end
    starter = "$$('.aCon').each(function(elem){Droppables.add(elem, {onDrop: function(elem){new Ajax.Request('/stuff', {".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});$$('.bCon').invoke('visualEffect','highlight');}})});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["asynchronous:true", "evalScripts:true", "method:'post'", "parameters:'id=' + elem.id"].should include(pair.strip)
    end
  end
      
end

describe 'Deprecated Prototype methods' do
  before(:each) do
    Mack::JavaScript::ScriptGenerator.framework = 'prototype'
    @p = Mack::JavaScript::ScriptGenerator.new
  end
  
  it "should translate tbe deprecated 'page.remote_function' to 'page.ajax'" do
    @p.remote_function(:url => '/stuff', :method => :put)
    starter = "new Ajax.Request('/stuff', {".gsub(/[()${}]/){|s| "\\#{s}"}
    ender = "});".gsub(/[()${}]/){|s| "\\#{s}"}
    @p.to_s =~ /^(#{starter})(.*)(#{ender})$/
    $1.should_not be(nil)
    $3.should_not be(nil)
    $2.split(',').each do |pair|
      ["asynchronous:true", "evalScripts:true", "method:'post'", "parameters:'_method=put'"].should include(pair.strip)
    end
  end
  
  it "should translate the deprecated 'page.insert_html' to selector equivalent" do
    @p.insert_html(:top, 'channelList', "<div id='newly_inserted'><p>Yowza</p></div>")
    @p.to_s.should == "$$('#channelList').invoke('insert',{top: '<div id=\\'newly_inserted\\'><p>Yowza<\\/p><\\/div>'});"
  end
  
  it "should translate the deprecated 'page.replace_html' to selector equivalent" do
    @p.replace_html('newly_inserted', "<p>Shazzam</p>")
    @p.to_s.should == "$$('#newly_inserted').invoke('update','<p>Shazzam<\\/p>');"
  end
  
  it "should translate the deprecated 'page.replace' to selector equivalent" do
    @p.replace('newly_inserted', "<div id='newly_inserted'><p>Bladow</p></div>")
    @p.to_s.should == "$$('#newly_inserted').invoke('replace','<div id=\\'newly_inserted\\'><p>Bladow<\\/p><\\/div>');"
  end
  
  it "should translate the deprecated 'page.remove' to selector equivalent" do
    #single id
    @p.remove('newly_inserted')
    @p.to_s.should == "$$('#newly_inserted').invoke('remove');"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.remove('newly_inserted', 'newly_inserted2')
    @p.to_s.should == "$$('#newly_inserted','#newly_inserted2').invoke('remove');"
  end
  
  it "should translate the deprecated 'page.show' to selector equivalent" do
    #single id
    @p.show('channelList')
    @p.to_s.should == "$$('#channelList').invoke('show');"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.show('channelList', 'searchResults')
    @p.to_s.should == "$$('#channelList','#searchResults').invoke('show');"
  end
  
  it "should translate the deprecated 'page.hide' to selector equivalent" do
    #single id
    @p.hide('channelList')
    @p.to_s.should == "$$('#channelList').invoke('hide');"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.hide('channelList', 'searchResults')
    @p.to_s.should == "$$('#channelList','#searchResults').invoke('hide');"
  end
  
  it "should translate the deprecated 'page.toggle' to selector equivalent" do
    #single id
    @p.toggle('channelList')
    @p.to_s.should == "$$('#channelList').invoke('toggle');"
    
    #multiple ids
    @p = Mack::JavaScript::ScriptGenerator.new
    @p.toggle('channelList', 'searchResults')
    @p.to_s.should == "$$('#channelList','#searchResults').invoke('toggle');"
  end
  
end
