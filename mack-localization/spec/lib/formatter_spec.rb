require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Localization::Formatter do
  it "should not blow up" do 
    true
  end
  
  it "should be able to format EN date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :en)
    str.should == ("Tuesday, January 01, 2008")
  end
  
  it "should be able to format FR date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :fr)
    str.should == ("Mardi, 01 Janvier, 2008")
  end
  
  it "should be able to format ES date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :es)
    str.should == ("Martes, 01 Enero, 2008")
  end
  
  it "should be able to format BP date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :bp)
    str.should == ("Terça, 01 Janeiro, 2008")
  end
  
  it "should be able to format IT date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :it)
    str.should == ("Martedì, 01 Gennaio, 2008")
  end
  
  it "should be able to format DE date using long_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :de)
    str.should == ("Dienstag, 01 Januar, 2008")
  end
  
  it "should be able to format EN date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :en)
    str.should == ("Tue, Jan 01, 2008")
  end
  
  it "should be able to format BP date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :bp)
    str.should == ("Ter, 01 Jan, 2008")
  end
  
  it "should be able to format FR date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :fr)
    str.should == ("Mar, 01 Jan, 2008")
  end
  
  it "should be able to format IT date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :it)
    str.should == ("Mar, 01 Gen, 2008")
  end
  
  it "should be able to format DE date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :de)
    str.should == ("Die, 01 Jan, 2008")
  end
  
  it "should be able to format ES date using medium_format" do
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :es)
    str.should == ("Mar, 01 Ene, 2008")
  end
  
  it "should be able to format EN date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :en)
    str.should == ("12/01/2008")
  end
  
  it "should be able to format BP date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :bp)
    str.should == ("01/12/2008")
  end
  
  it "should be able to format ES date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :es)
    str.should == ("01/12/2008")
  end
  
  it "should be able to format FR date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :fr)
    str.should == ("01/12/2008")
  end
  
  it "should be able to format DE date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :de)
    str.should == ("01/12/2008")
  end
  
  it "should be able to format IT date using short_format" do
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :it)
    str.should == ("01/12/2008")
  end
  
  it "should be able to format number in EN language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :en)
    str.should == ("12,000.50")
  end
  
  it "should be able to format number in FR language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :fr)
    str.should == ("12 000,50")
  end
  
  it "should be able to format number in DE language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :de)
    str.should == ("12.000,50")
  end
  
  it "should be able to format number in IT language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :it)
    str.should == ("12.000,50")
  end
  
  it "should be able to format number in ES language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :es)
    str.should == ("12.000,50")
  end
  
  it "should be able to format number in BP language" do
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :bp)
    str.should == ("12,000.50")
  end
  
  it "should be able to format currency in EN language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :en)
    str.should == ("$12,000.50")
  end
  
  it "should be able to format currency in FR language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :fr)
    str.should == ("€12 000,50")
  end
  
  it "should be able to format currency in DE language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :de)
    str.should == ("€12.000,50")
  end
  
  it "should be able to format currency in IT language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :it)
    str.should == ("€12.000,50")
  end
  
  it "should be able to format currency in ES language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :es)
    str.should == ("€12.000,50")
  end
  
  it "should be able to format currency in BP language" do
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :bp)
    str.should == ("R$12,000.50")
  end

end
