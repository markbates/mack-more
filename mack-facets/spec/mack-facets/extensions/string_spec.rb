require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe String do
  
  describe '/' do
    
    it 'should join strings together like File.join' do
      ('a' / 'b').should == File.join('a', 'b')
      ('a' / 'b' / :c).should == File.join('a', 'b', 'c')
    end
    
  end
  
  describe "methodize" do
    
    it "should convert the String into a Ruby method friendly String" do
      "Who's your daddy?".methodize.should == "who_s_your_daddy?"
      "1@%$^&foo**((*))_bar?".methodize.should == "foo_bar?"
      "1@%$^&foo**((*))_bar&&&sdfsdf____".methodize.should == "foo_bar_sdfsdf"
      "\nfoo_\tbar".methodize.should == "foo_bar"
      "foo?bar".methodize.should == "foo_bar"
      "foo!bar".methodize.should == "foo_bar"
      "foo=bar".methodize.should == "foo_bar"
      "foo-bar".methodize.should == "foo_bar"
      "foo 123".methodize.should == "foo_123"
      "foo!!!!!!!!!!!123$$$$$$$$$".methodize.should == "foo_123"
      "DebateSide".methodize.should == "debate_side"
      %{
      Littera gothica quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis. Adipiscing elit sed; diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat? Decima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in? Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum typi! Blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla?
    
      Consequat duis autem vel eum iriure dolor in hendrerit in vulputate velit esse. Ut laoreet dolore magna aliquam erat volutpat ut wisi enim ad minim veniam quis nostrud exerci. Ea commodo molestie consequat vel illum dolore eu feugiat nulla facilisis at vero eros et. Placerat facer possim assum typi non habent claritatem insitam? Modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Elit sed diam nonummy nibh euismod tincidunt tation ullamcorper suscipit lobortis nisl ut aliquip ex accumsan. Littera gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis per seacula, quarta decima et.
    
      Quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Hendrerit in vulputate velit esse molestie consequat vel illum dolore eu. Claram anteposuerit litterarum formas humanitatis per seacula quarta decima et. Feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit. Zzril delenit augue duis dolore te feugait nulla facilisi nam? Processus dynamicus qui sequitur mutationem consuetudium lectorum mirum est notare quam. Vel eum iriure dolor in praesent luptatum liber tempor cum soluta nobis eleifend option congue. Quod ii legunt saepius claritas est etiam; littera gothica quam nunc putamus parum?
    
      In iis qui facit eorum claritatem Investigationes demonstraverunt lectores legere me. Veniam quis nostrud exerci tation ullamcorper suscipit lobortis. Dolor sit amet consectetuer adipiscing elit sed diam, nonummy nibh euismod tincidunt ut laoreet! Iusto odio dignissim, qui blandit praesent luptatum zzril! Quod mazim placerat facer possim assum typi non habent claritatem insitam est usus legentis lius quod!
    
      }.methodize.should == "littera_gothica_quam_nunc_putamus_parum_claram_anteposuerit_litterarum_formas_humanitatis_adipiscing"
      "foo =".methodize.should == "foo="
      "12345fo!!!!@@@@@@@@[[[]]]o%%%~~~`````=".methodize.should == "fo_o="
      lambda{ "!!!!!!!!!!!!!!!!".methodize }.should raise_error(NameError)
      lambda{ "????????????????".methodize }.should raise_error(NameError)
      lambda{ "1234567890".methodize }.should raise_error(NameError)
      lambda{ "".methodize }.should raise_error(NameError)
    end
    
  end
  
  describe "constantize" do
    
    it "should return a Constant based on the String" do
      "Orange".constantize.should == Orange
      "Animals::Dog::Poodle".constantize.should == Animals::Dog::Poodle
    end
    
  end
  
  describe "hexdigest" do
    
    it "should return a Digest::SHA1.hexdigest version of the String" do
      "Hello World".hexdigest.should == "0a4d55a8d778e5022fab701977c5d840bbc486d0"
    end
    
    describe "!" do
      
      it "should destructively replace the string with a Digest::SHA1.hexdigest version" do
        x = "Hello World"
        x.hexdigest!.should == "0a4d55a8d778e5022fab701977c5d840bbc486d0"
        x.should == "0a4d55a8d778e5022fab701977c5d840bbc486d0"
      end
      
    end
    
  end
  
  describe "randomize" do
    
    it "should return a random String with a specified length" do
      String.randomize.size.should == 10
      String.randomize(5).size.should == 5
      String.randomize.should_not be_nil
    end
    
  end
  
  describe "uri_escape" do
    
    it "should escape a String to make it url 'safe'" do
      "Hello World!@!".uri_escape.should == "Hello+World%21%40%21"
    end
    
  end
  
  describe "uri_unescape" do
    
    it "should unescape a url 'safe' String" do
      "Hello+World%21%40%21".uri_unescape.should == "Hello World!@!"
    end
    
  end
  
end