desc "Release the gem"
task :release => :install do |t|
  begin
    ac_path = File.join(ENV["HOME"], ".rubyforge", "auto-config.yml")
    if File.exists?(ac_path)
      fixed = File.open(ac_path).read.gsub("  ~: {}\n\n", '')
      puts "Fixing #{ac_path}..."
      File.open(ac_path, "w") {|f| f.puts fixed}
    end
    rf = RubyForge.new
    rf.login
    begin
      rf.add_release(@gem_spec.rubyforge_project, @gem_spec.name, @gem_spec.version, File.join("pkg", "#{@gem_spec.name}-#{@gem_spec.version}.gem"))
    rescue Exception => e
      if e.message.match("Invalid package_id") || e.message.match("no <package_id> configured for")
        puts "You need to create the package!"
        rf.create_package(@gem_spec.rubyforge_project, @gem_spec.name)
        rf.add_release(@gem_spec.rubyforge_project, @gem_spec.name, @gem_spec.version, File.join("pkg", "#{@gem_spec.name}-#{@gem_spec.version}.gem"))
      else
        raise e
      end
    end
  rescue Exception => e
    puts e
  end
end