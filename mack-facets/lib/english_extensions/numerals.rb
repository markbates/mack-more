class Integer #:nodoc:

  #
  #   10.english #=> 'ten'

  include English::Numerals

  def english
    self.name(self)
  end

end