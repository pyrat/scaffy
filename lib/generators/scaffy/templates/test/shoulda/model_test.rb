require 'test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
  
  should "create successfully" do
    <%= object_singular %> = Factory(:<%= object_singular %>)
  end
    
end
