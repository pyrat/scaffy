require 'test_helper'

class <%= plural_class_name %>ControllerTest < ActionController::TestCase
  
  # This is used for logging in etc.
  def setup
    @<%= singular_name %> = create_<%= class_name.downcase %>
    assert(@<%= singular_name %>.id, "Virtual fixture not valid.")
  end
  
  
  <%= controller_methods 'tests/testunit/actions' %>
  
  private
  
  # These might belong in test_helper.rb
  
  def create_<%= class_name.downcase %>(options = {})
    <%= class_name %>.create(
      get_<%= class_name.downcase %>_hash(options)
    )
  end

  def get_<%= class_name.downcase %>_hash(options = {})
    {
      <%- for attribute in attributes -%>
        <%- i ||= 1 -%>
        :<%= attribute.name %> => "<%= attribute.default %>"<%= "," unless(i == attributes.size) %>
        <%- i += 1 -%>
      <%- end -%>
    }.merge(options)
  end 
  
end
