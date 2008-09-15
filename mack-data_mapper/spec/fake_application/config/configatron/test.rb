configatron do |c|
  c.namespace(:mack) do |mack|
    mack.namespace(:log) do |log|
      log.level = :debug
    end
  end
end

