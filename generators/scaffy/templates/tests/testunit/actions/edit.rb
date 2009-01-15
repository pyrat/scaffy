  def test_edit
    get :edit, :id => @<%= singular_name %>.id
    assert_template 'new'
  end
