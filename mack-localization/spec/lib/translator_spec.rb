require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Localization::Translator do
  
  it "should not blow up" do 
    true
  end
  
  it "should be able to properly handle multibyte string" do
    a = "çã"
    # ruby < 1.9 doesn't have unicode support
    a.size.should_not == 2
    
    a = u("çã")
    a.size.should == 2
    a.reverse.should == "ãç"
  end
  
  it "should be able to retrieve data for EN language" do
    key = :sale
    str = l10n_translator.gets(:items, key, :en)
    str.should == "This application is for sale for "
  end
  
  it "should be able to retrieve data for BP language" do
    key = :sale
    str = l10n_translator.gets(:items, key, :bp)
    str.should == "Esta aplicação está à venda para "
  end
  
  it "should be able to retrieve data for FR language" do
    key = :sale
    str = l10n_translator.gets(:items, key, :fr)
    str.should == "Cette application est en vente pour "
  end
  
  it "should be able to retrieve data for ES language" do 
    key = :sale
    str = l10n_translator.gets(:items, key, :es)
    str.should == "Esta aplicación está a la venta para "
  end
  
  it "should be able to retrieve data for DE language" do
    key = :sale
    str = l10n_translator.gets(:items, key, :de)
    str.should == "Diese Anwendung ist für den Verkauf zu "
  end
  
  it "should be able to retrieve data for IT language" do
    key = :sale
    str = l10n_translator.gets(:items, key, :it)
    str.should == "Questa applicazione è in vendita per "
  end
  
end