module ApplicationHelper
  
  def language_links
    links = l10n_gets(:set_lang).to_s
    @supported_languages.each do |lang|
      links += link_to lang.to_s.upcase, "/items/set_lang/#{lang}"
      links += " "
    end
    return links
  end
end
