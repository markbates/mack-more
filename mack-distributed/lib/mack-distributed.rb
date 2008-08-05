base = File.join(File.dirname(__FILE__), "mack-distributed")

def traverse_and_require(path)
  Dir.entries(path).each do |file|
    next if file == "." or file == ".."
    full_path = File.join(path, file)
    if FileTest.directory?(full_path)
      traverse_and_require(full_path)
    else
      require full_path
    end
  end
end

traverse_and_require(base)