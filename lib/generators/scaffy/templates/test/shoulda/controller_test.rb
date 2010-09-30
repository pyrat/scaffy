require 'test_helper'

class <%= human_name %>ControllerTest < ActionController::TestCase
  
  context "testing controller" do
    
    # May want to add some login info here.
    setup do
      @<%= object_singular %> = Factory(:<%= object_singular %>)
    end
    
    
    should "get index" do
      get :index
      assert_response :success, @response.body
    end
    
    should "get new" do
      get :new
      assert_response :success, @response.body
    end
    
    should "create successfully" do
      post :create, Factory.attributes_for(:<%= object_singular %>)
      assert_response :redirect, @response.body
      assert_redirected_to <%= index_url %>
    end
    
    should "get edit" do
      get :edit, :id => @<%= object_singular %>.id
      assert_response :success, @response.body
    end
    
    should "show successfully" do
      get :show, :id => @<%= object_singular %>.id
      assert_response :success, @response.body
    end
    
    should "update successfully" do
      put :update, :id => @<%= object_singular %>.id, :<%= object_singular %> => Factory.attributes_for(:<%= object_singular %>)
      assert_response :redirect, @response.body
      assert_redirected_to <%= index_url %>
    end
    
    should "destroy successfully" do
      delete :destroy, :id => @<%= object_singular %>.id
      assert_response :redirect, @response.body
      assert_redirected_to <%= index_url %>
    end
    
  end
  
  
end
