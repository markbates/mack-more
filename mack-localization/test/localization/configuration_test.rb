require File.dirname(__FILE__) + '/../test_helper.rb'

class ConfigurationTest < Test::Unit::TestCase
  
  def test_object_level_methods
    assert self.respond_to?(:l10n_config)
    assert l10n_config == app_config
  end
  
  def test_proper_config_from_app
    assert !(base_lang = l10n_config.base_language).nil?
    assert !(base_lang.empty?)
    assert !(supported_languages = l10n_config.supported_languages).nil?
    assert !(supported_languages.empty?)
    assert !(char_encoding = l10n_config.char_encoding).nil?
    assert !(char_encoding.empty?)
    assert !(dynamic_translation = l10n_config.dynamic_translation).nil?
    assert !(base_directory = l10n_config.base_directory).nil?
    assert !(base_directory.empty?)
    assert !(content_expiry = l10n_config.content_expiry).nil?
  end
  
end