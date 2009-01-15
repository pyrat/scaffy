  def test_show
    get :show, :id => @<%= singular_name %>.id
    assert_template 'show'
  end
