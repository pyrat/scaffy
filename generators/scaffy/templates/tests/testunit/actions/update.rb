  def test_update_invalid
    <%= class_name %>.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @<%= singular_name %>.id
    assert_response :success, @response.body
    assert_template 'new'
  end
  
  def test_update_valid
    <%= class_name %>.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @<%= singular_name %>.id
    assert_redirected_to <%= index_name %>_url
  end
