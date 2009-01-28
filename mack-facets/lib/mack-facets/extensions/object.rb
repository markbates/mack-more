class Object
  
  def meta_class() class << self; self end end
  
  def define_instance_method(sym, &block)
    mod = Module.new do
      define_method(sym, &block)
    end
    self.extend mod
  end
  
  # Includes a module into the current Class, and changes all the module's public methods to protected.
  # 
  # Example:
  #   class FooController
  #     safely_include_module(MyCoolUtils, MyOtherModule)
  #   end
  def safely_include_module(*modules)
    [modules].flatten.each do |mod|
      mod.include_safely_into(self)
    end
  end
  
  # Prints out the methods associated with this object in alphabetical order.
  def print_methods
    m = "----- #{self} (methods) -----\n"
    m << methods.sort.join("\n")
    puts m
    m
  end

  # An elegant way to refactor out common options
  # 
  #   with_options :order => 'created_at', :class_name => 'Comment' do |post|
  #     post.has_many :comments, :conditions => ['approved = ?', true], :dependent => :delete_all
  #     post.has_many :unapproved_comments, :conditions => ['approved = ?', false]
  #     post.has_many :all_comments
  #   end
  #
  # Can also be used with an explicit receiver:
  #
  #   map.with_options :controller => "people" do |people|
  #     people.connect "/people",     :action => "index"
  #     people.connect "/people/:id", :action => "show"
  #   end
  #  
  def with_options(options)
    yield Mack::Utils::OptionMerger.new(self, options)
  end
  
  # See Class parents for more information.
  def class_parents
    self.class.parents
  end
  
  # This method gets called when a parameter is passed into a named route.
  # This can be overridden in an Object to provlde custom handling of parameters.
  def to_param
    self.to_s
  end
  
  # Uses <code>define_method</code> to create an empty for the method parameter defined.
  # That method will then raise MethodNotImplemented. This is useful for creating interfaces
  # and you want to stub out methods that others need to implement.
  def self.needs_method(meth)
    define_method(meth) do
      raise NoMethodError.new("The interface you are using requires you define the following method '#{meth}'")
    end
  end
  
  # This prints out running time for the block provided. This is great for things
  # like Rake tasks, etc... where you would like to know how long it, or a section of
  # it took to run.
  def running_time(message = "", logger = nil)
    s_time = Time.now
    s = "---Starting at #{s_time}---"
    puts s
    logger.info s unless logger.nil?
    yield if block_given?
    e_time = Time.now
    e = "---Ending at #{e_time}---"
    puts e
    logger.info e unless logger.nil?
    secs = e_time - s_time
    if secs < 60
      x = "Running time #{secs} seconds."
    else
      x = "Running time roughly #{secs/60} minutes [#{secs} seconds]"
    end
    x += " [MESSAGE]: #{message}" unless message.blank?
    puts x
    logger.info x unless logger.nil?
  end
  
  # This method will call send to all the methods defined on the previous method.
  # 
  # Example:
  #   Fruit.send_with_chain([:new, :get_citrus, :get_orange, :class]) # => Orange
  # 
  # This would be the equivalent:
  #   Fruit.new.get_citrus.get_orange.class
  def send_with_chain(methods, *args)
    obj = self
    [methods].flatten.each {|m| obj = obj.send(m, *args)}
    obj
  end
  
  # ivar_cache allows you to cache the results of the block into an instance variable in a class,
  # and then will serve up that instance variable the next time you call that method again.
  # 
  # old way:
  #   def show_page_link
  #     unless @show_page_link # check if instance variable exists
  #       # if the instance variable doesn't exist let's do some work and assign it to the instance variable.
  #       @show_page_link = link_to("show", some_url(:id => self.id, :foo => bar, etc... => etc))
  #     end
  #     @show_page_link # now return the instance variable
  #   end
  # 
  # new way:
  #   def show_page_link
  #     ivar_cache do
  #       link_to("show", some_url(:id => self.id, :foo => bar, etc... => etc))
  #     end
  #   end
  # 
  # this does everything the old way did, but it is much cleaner, and a lot less code!
  # in case you're wondering it caches the result, by default, to an instance variable named after the method,
  # so in our above example the instance variable would be name, <code>@show_page_link</code>. this can be overridden like such:
  # 
  #   def show_page_link
  #     ivar_cache("foo_var") do
  #       link_to("show", some_url(:id => self.id, :foo => bar, etc... => etc))
  #     end
  #   end
  # 
  # now it will cache it to <code>@foo_var</code>
  def ivar_cache(var_name = nil, &block)
    if var_name.nil?
      call = caller[0]
      var_name = call[(call.index('`')+1)...call.index("'")]
    end
    var = instance_variable_get("@#{var_name}")
    unless var
      return instance_variable_set("@#{var_name}", yield) if block_given?
    end
    instance_variable_get("@#{var_name}")
  end
  
  def ivar_cache_clear(var_name = nil, &block)
    if var_name.nil?
      call = caller[0]
      var_name = call[(call.index('`')+1)...call.index("'")]
    end
    remove_instance_variable("@#{var_name}") #rescue
    yield if block_given?
  end
  
  # Returns the namespaces for a particular object.
  # 
  # Examples:
  #   Animals::Dog::Poodle.new.namespaces # => ["Animals", "Dog"]
  def namespaces
    ivar_cache("object_namespaces") do
      nss = []
      full_name = self.class.name.to_s
      nss = full_name.split("::")
      nss.pop
      nss
    end
  end
  
end