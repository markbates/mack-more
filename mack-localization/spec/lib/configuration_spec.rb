require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Localization::Configuration do
  
  it "should not blow up" do 
    true
  end
  
  it "should contain proper Object level methods" do
    self.should.respond_to?(:l10n_config)
    l10n_config.should.eql?(app_config)
    self.should.respond_to?(:l10n_formatter)
    self.should.respond_to?(:l10n_translator)
  end
  
  it "should properly load config from app" do
    
    (base_lang = l10n_config.base_language).should_not be_nil
    base_lang.should_not be_empty
    
    (supported_languages = l10n_config.supported_languages).should_not be_nil
    supported_languages.should_not be_empty
    
    (char_encoding = l10n_config.char_encoding).should_not be_nil
    char_encoding.should_not be_empty
    
    (dynamic_translation = l10n_config.dynamic_translation).should_not be_nil
    
    (base_directory = l10n_config.base_directory).should_not be_nil
    base_directory.should_not be_empty
    
    (content_expiry = l10n_config.content_expiry).should_not be_nil
  end
  
end