require 'ruby-debug'

class ItemsController < DefaultController
  before_filter :init_session
  
  def init_session
    session[:lang] ||= :en
  end
   
  def index
    @supported_languages = l10n_config.supported_languages.sort
  end
  
  def index2
    @supported_languages = l10n_config.supported_languages.sort
  end
  
  def set_lang
    puts "id = #{params(:id)}"
    session[:lang] = params(:id)
    redirect_to(items_index_url)
  end
end