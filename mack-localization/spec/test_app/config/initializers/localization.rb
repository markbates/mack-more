l10n_config.setup do |config|
  config.base_language = 'fr'
  config.supported_languages = ['bp', 'en', 'fr', 'it', 'es', 'de']
  config.char_encoding = 'utf-8'
  config.dynamic_translation = true
  config.content_expiry = 10
  config.base_directory = Mack::Paths.app('lang')
end
  