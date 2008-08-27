# module DataMapper # :nodoc:
#   module Model # :nodoc:
# 
#     def property(name, type, options = {})
#       property = Property.new(self, name, type, options)
# 
#       create_property_getter(property)
#       create_property_setter(property)
# 
#       @properties[repository_name][property.name] = property
# 
#       # Add property to the other mappings as well if this is for the default
#       # repository.
#       if repository_name == default_repository_name
#         @properties.each_pair do |repository_name, properties|
#           next if repository_name == default_repository_name
#           properties << property
#         end
#       end
# 
#       # Add the property to the lazy_loads set for this resources repository
#       # only.
#       # TODO Is this right or should we add the lazy contexts to all
#       # repositories?
#       if property.lazy?
#         context = options.fetch(:lazy, :default)
#         context = :default if context == true
# 
#         Array(context).each do |item|
#           @properties[repository_name].lazy_context(item) << name
#         end
#       end
# 
#       # add the property to the child classes only if the property was
#       # added after the child classes' properties have been copied from
#       # the parent
#       if respond_to?(:descendants)
#         descendants.each do |model|
#           next if model.properties(repository_name).has_property?(name)
#           model.property(name, type, options)
#         end
#       end
# 
#       property
#     end
#     
#   end # module Model
# end # module DataMapper
