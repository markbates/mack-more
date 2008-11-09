class String

  # Prepend an "@" to the beginning of a string
  # to make a instance variable name. This also replaces
  # non-valid characters with underscores.

  def variablize
    "@#{self}".gsub(/\W/, '_').to_s
  end

end

