require File.join(File.dirname(__FILE__), "inflector")
# Default inflections. This is taken from Jeremy McAnally's great Rails plugin, acts_as_good_speeler. Thanks Jeremy! http://www.jeremymcanally.com/
Mack::Utils::Inflector.inflections do |inflect|
  inflect.plural('ors', 'ors')
  inflect.plural('ats', 'ats')
  inflect.plural('us', 'i')
  # # inflect.plural(/$/, 's')
  # inflect.plural(/s$/i, 's')
  # inflect.plural(/(bu)s$/i, '\1ses')
  # inflect.plural(/(stimul|hippopotam|octop|vir|syllab|foc|alumn|fung|radi)us$/i, '\1i')
  # inflect.plural(/(ax|test)is$/i, '\1es')
  # inflect.plural(/(alias|status)$/i, '\1es')
  # inflect.plural(/(buffal|tomat|torped)o$/i, '\1oes')
  # inflect.plural(/([dti])um$/i, '\1a')
  # inflect.plural(/sis$/i, 'ses')
  # inflect.plural(/(?:([^f])fe|([lr])f)$/i, '\1\2ves')
  # inflect.plural(/(hive)$/i, '\1s')
  # inflect.plural(/([^aeiouy]|qu)y$/i, '\1ies')
  # inflect.plural(/(x|ch|ss|sh)$/i, '\1es')
  # inflect.plural(/(matr|append|vert|ind)ix|ex$/i, '\1ices')
  # inflect.plural(/([m|l])ouse$/i, '\1ice')
  # inflect.plural(/^(ox)$/i, '\1en')
  # inflect.plural(/(quiz)$/i, '\1zes')
  # inflect.plural(/(phenomen|criteri)on$/i, '\1a')
  # inflect.plural(/^(?!(.*hu|.*ger|.*sha))(.*)(wom|m)an$/i, '\2\3en')
  # inflect.plural(/(curricul|bacteri|medi)um$/i, '\1a')
  # inflect.plural(/(nebul|formul|vit|vertebr|alg|alumn)a$/i, '\1ae')
  # 
  # # inflect.singular(/s$/i, '')
  # inflect.singular(/(n)ews$/i, '\1ews')
  # inflect.singular(/([dti])a$/i, '\1um')
  # inflect.singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, '\1\2sis')
  # inflect.singular(/(^analy|cri|empha)ses$/i, '\1sis')
  # inflect.singular(/([^f])ves$/i, '\1fe')
  # inflect.singular(/(hive)s$/i, '\1')
  # inflect.singular(/(tive)s$/i, '\1')
  # inflect.singular(/(bus)es$/i, '\1')
  # inflect.singular(/(o)es$/i, '\1')
  # inflect.singular(/(shoe)s$/i, '\1')
  # inflect.singular(/(test|ax)es$/i, '\1is')
  # inflect.singular(/(stimul|hippopotam|octop|vir|syllab|foc|alumn|fung|radi)i$/i, '\1us')
  # inflect.singular(/(alias|status)es$/i, '\1')
  # inflect.singular(/^(ox)en$/i, '\1')
  # inflect.singular(/(vert|ind)ices$/i, '\1ex')
  # inflect.singular(/(matr|append)ices$/i, '\1ix')
  # inflect.singular(/(quiz)zes$/i, '\1')
  # inflect.singular(/(phenomen|criteri)a$/i, '\1on')
  # inflect.singular(/(.*)(wo|m)en$/i, '\1\2an')
  # inflect.singular(/(medi|curricul|bacteri)a$/i, '\1um')
  # inflect.singular(/(nebula|formula|vita|vertebra|alga|alumna)e$/i, '\1')
  # inflect.singular(/^(.*)ookies$/, '\1ookie')
  # inflect.singular(/(.*)ss$/, '\1ss')
  # inflect.singular(/(.*)ies$/, '\1y')

  inflect.irregular('person', 'people')
  inflect.irregular('child', 'children')
  inflect.irregular('sex', 'sexes')
  inflect.irregular('move', 'moves')
  inflect.irregular('tooth', 'teeth')
  inflect.irregular('die', 'dice')
  inflect.irregular('talisman', 'talismans')
  inflect.irregular('penis', 'penises')
  inflect.irregular('christmas', 'christmases')
  inflect.irregular('knowledge', 'knowledge')
  inflect.irregular('quiz', 'quizzes')
end