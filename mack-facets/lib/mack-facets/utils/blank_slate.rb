class Mack::Utils::BlankSlate
  instance_methods.each { |m| undef_method m unless m =~ /^__/ }
end