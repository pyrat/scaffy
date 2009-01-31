require File.join(File.dirname(__FILE__), "test_helper.rb")

require 'rails_generator'

class TestScaffyGenerator < Test::Unit::TestCase
  
  include ScaffyGenerators::TestHelper

  # Some generator-related assertions:
  #   assert_generated_file(name, &block) # block passed the file contents
  #   assert_directory_exists(name)
  #   assert_generated_class(name, &block)
  #   assert_generated_module(name, &block)
  #   assert_generated_test_for(name, &block)
  # The assert_generated_(class|module|test_for) &block is passed the body of the class/module within the file
  #   assert_has_method(body, *methods) # check that the body has a list of methods (methods with parentheses not supported yet)
  #
  # Other helper methods are:
  #   app_root_files - put this in teardown to show files generated by the test method (e.g. p app_root_files)
  #   bare_setup - place this in setup method to create the APP_ROOT folder for each test
  #   bare_teardown - place this in teardown method to destroy the TMP_ROOT or APP_ROOT folder after each test

  context "routed" do
    setup do
      Dir.mkdir("#{RAILS_ROOT}/config") unless File.exists?("#{RAILS_ROOT}/config")
      File.open("#{RAILS_ROOT}/config/routes.rb", 'w') do |f|
        f.puts "ActionController::Routing::Routes.draw do |map|\n\nend"
      end
    end

    teardown do
      FileUtils.rm_rf "#{RAILS_ROOT}/config"
    end

    context "generator without name" do
      should "raise usage error" do
        assert_raise Rails::Generator::UsageError do
          # run_rails_generator :scaffy_generator
          assert true
        end
      end
    end

    # context "generator with no options and no existing model" do
    #       rails_generator :scaffy, "LineItem"
    # 
    #       should_generate_file "app/helpers/line_items_helper.rb"
    # 
    #       should "generate controller with class as camelcase name pluralized and all actions" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "class LineItemsController < ApplicationController", body
    #           %w[index show new create edit update destroy].each do |action|
    #             assert_match "def #{action}", body
    #           end
    #         end
    #       end
    # 
    #       %w[index show new edit].each do |action|
    #         should_generate_file "app/views/line_items/#{action}.html.erb"
    #       end
    # 
    #       should "have name attribute" do
    #         assert_generated_file "app/views/line_items/_form.html.erb" do |body|
    #           assert_match "<%= f.text_field :name %>", body
    #         end
    #       end
    # 
    #       should "add map.resources line to routes" do
    #         assert_generated_file "config/routes.rb" do |body|
    #           assert_match "map.resources :line_items", body
    #         end
    #       end
    # 
    #       should_not_generate_file "app/models/line_item.rb"
    #     end
    # 
    #     context "generator with some attributes" do
    #       rails_generator :scaffy_generator, "line_item", "name:string", "description:text"
    # 
    #       should "generate migration with attribute columns" do
    #         file = Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").first
    #         assert file, "migration file doesn't exist"
    #         assert_match(/[0-9]+_create_line_items.rb$/, file)
    #         assert_generated_file "db/migrate/#{File.basename(file)}" do |body|
    #           assert_match "class CreateLineItems", body
    #           assert_match "t.string :name", body
    #           assert_match "t.text :description", body
    #           assert_match "t.timestamps", body
    #         end
    #       end
    # 
    #       should "generate model with class as camelcase name" do
    #         assert_generated_file "app/models/line_item.rb" do |body|
    #           assert_match "class LineItem < ActiveRecord::Base", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with index action" do
    #       rails_generator :scaffy, "line_item", "index"
    # 
    #       should_generate_file "app/views/line_items/index.html.haml"
    # 
    #       should "generate controller with index action" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def index", body
    #           assert_match "@line_items = LineItem.all", body
    #           assert_no_match(/    def index/, body)
    #         end
    #       end
    #     end
    # 
    #     context "generator with show action" do
    #       rails_generator :scaffy, "line_item", "show"
    # 
    #       should_generate_file "app/views/line_items/show.html.haml"
    # 
    #       should "generate controller with show action" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def show", body
    #           assert_match "@line_item = LineItem.find(params[:id])", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with new and create actions" do
    #       rails_generator :scaffy, "line_item", "new", "create"
    # 
    #       should_not_generate_file "app/views/line_items/create.html.haml"
    #       should_not_generate_file "app/views/line_items/_form.html.haml"
    # 
    #       should "render form in 'new' template" do
    #         assert_generated_file "app/views/line_items/new.html.haml" do |body|
    #           assert_match "<% form_for @line_item do |f| %>", body
    #         end
    #       end
    # 
    #       should "generate controller with actions" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def new", body
    #           assert_match "@line_item = LineItem.new\n", body
    #           assert_match "def create", body
    #           assert_match "@line_item = LineItem.new(params[:line_item])", body
    #           assert_match "if @line_item.save", body
    #           assert_match "flash[:notice] = \"Successfully created line item.\"", body
    #           assert_match "redirect_to line_items_url", body
    #           assert_match "render :action => 'new'", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with edit and update actions" do
    #       rails_generator :scaffy, "line_item", "edit", "update"
    # 
    #       should_not_generate_file "app/views/line_items/update.html.haml"
    #       should_not_generate_file "app/views/line_items/_form.html.haml"
    # 
    #       should "render form in 'edit' template" do
    #         assert_generated_file "app/views/line_items/edit.html.haml" do |body|
    #           assert_match "<% form_for @line_item do |f| %>", body
    #         end
    #       end
    # 
    #       should "generate controller with actions" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def edit", body
    #           assert_match "@line_item = LineItem.find(params[:id])", body
    #           assert_match "def update", body
    #           assert_match "if @line_item.update_attributes(params[:line_item])", body
    #           assert_match "flash[:message] = \"Successfully updated line item.\"", body
    #           assert_match "redirect_to line_items_url", body
    #           assert_match "render :action => 'edit'", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with edit and update actions" do
    #       rails_generator :scaffy, "line_item", "destroy"
    # 
    #       should_not_generate_file "app/views/line_items/destroy.html.haml"
    # 
    #       should "generate controller with action" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def destroy", body
    #           assert_match "@line_item = LineItem.find(params[:id])", body
    #           assert_match "@line_item.destroy", body
    #           assert_match "flash[:message] = \"Successfully destroyed line item.\"", body
    #           assert_match "redirect_to line_items_url", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with new and edit actions" do
    #       rails_generator :scaffy, "line_item", "new", "edit"
    # 
    #       should_generate_file "app/views/line_items/_form.html.haml"
    # 
    #       should "render the form partial in views" do
    #         %w[new edit].each do |action|
    #           assert_generated_file "app/views/line_items/#{action}.html.erb" do |body|
    #             assert_match "<%= render :partial => 'form' %>", body
    #           end
    #         end
    #       end
    #     end
    # 
    #     context "generator with attributes and actions" do
    #       rails_generator :scaffy, "line_item", "name:string", "new", "price:float", "index", "available:boolean"
    # 
    #       should "render a form field for each attribute in 'new' template" do
    #         assert_generated_file "app/views/line_items/new.html.haml" do |body|
    #           assert_match "<%= f.text_field :name %>", body
    #           assert_match "<%= f.text_field :price %>", body
    #           assert_match "<%= f.check_box :available %>", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with show, create, and update actions" do
    #       rails_generator :scaffy, "line_item", "show", "create", "update"
    # 
    #       should "redirect to line item show page, not index" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "redirect_to @line_item", body
    #           assert_no_match(/redirect_to line_items_url/, body)
    #         end
    #       end
    #     end
    # 
    #     context "generator with attributes and skip model option" do
    #       rails_generator :scaffy, "line_item", "foo:string", :skip_model => true
    # 
    #       should "use passed attribute" do
    #         assert_generated_file "app/views/line_items/_form.html.haml" do |body|
    #           assert_match "<%= f.text_field :foo %>", body
    #         end
    #       end
    # 
    #       should "not generate migration file" do
    #         assert Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").empty?
    #       end
    # 
    #       should_not_generate_file "app/models/line_item.rb"
    #     end
    # 
    #     context "generator with no attributes" do
    #       rails_generator :scaffy, "line_item"
    # 
    #       should "not generate migration file" do
    #         assert Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").empty?
    #       end
    # 
    #       should_not_generate_file "app/models/line_item.rb"
    #     end
    # 
    #     context "generator with only new and edit actions" do
    #       rails_generator :scaffy, "line_item", "new", "edit"
    # 
    #       should "included create and update actions in controller" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           assert_match "def create", body
    #           assert_match "def update", body
    #         end
    #       end
    #     end
    # 
    #     context "generator with exclemation mark and show, new, and edit actions" do
    #       rails_generator :scaffy, "line_item", "!", "show", "new", "edit"
    # 
    #       should "only include index and destroy actions" do
    #         assert_generated_file "app/controllers/line_items_controller.rb" do |body|
    #           %w[index destroy].each { |a| assert_match "def #{a}", body }
    #           %w[show new create edit update].each do |a|
    #             assert_no_match(/def #{a}/, body)
    #           end
    #         end
    #       end
    #     end
    # 
    #     context "generator with --skip-controller" do
    #       rails_generator :scaffy, "line_item", :skip_controller => true
    #       should_not_generate_file "app/controllers/line_items_controller.rb"
    #       should_not_generate_file "app/helpers/line_items_helper.rb"
    #       should_not_generate_file "app/views/line_items/index.html.haml"
    #     end
    # 
    #     context "generator with --skip-migration" do
    #       rails_generator :scaffy, "line_item", "name:string", :skip_migration => true
    # 
    #       should "not generate migration file" do
    #         assert Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").empty?
    #       end
    #     end
    # 
    #     context "generator with --skip-timestamps" do
    #       rails_generator :scaffy, "line_item", "name:string", :skip_timestamps => true
    # 
    #       should "generate migration with no timestamps" do
    #         file = Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").first
    #         assert file, "migration file doesn't exist"
    #         assert_generated_file "db/migrate/#{File.basename(file)}" do |body|
    #           assert_no_match(/t.timestamps/, body)
    #         end
    #       end
    #     end
    # 
    #     context "existing model" do
    #       setup do
    #         Dir.mkdir("#{RAILS_ROOT}/app") unless File.exists?("#{RAILS_ROOT}/app")
    #         Dir.mkdir("#{RAILS_ROOT}/app/models") unless File.exists?("#{RAILS_ROOT}/app/models")
    #         File.open("#{RAILS_ROOT}/app/models/recipe.rb", 'w') do |f|
    #           f.puts "raise 'should not be loaded'"
    #         end
    #       end
    # 
    #       teardown do
    #         FileUtils.rm_rf "#{RAILS_ROOT}/app"
    #       end
    # 
    #       context "generator with skip model option" do
    #         rails_generator :scaffy, "recipe", :skip_model => true
    # 
    #         should "use model columns for attributes" do
    #           assert_generated_file "app/views/recipes/_form.html.erb" do |body|
    #             assert_match "<%= f.text_field :foo %>", body
    #             assert_match "<%= f.text_field :bar %>", body
    #             assert_match "<%= f.text_field :book_id %>", body
    #             assert_no_match(/:id/, body)
    #             assert_no_match(/:created_at/, body)
    #             assert_no_match(/:updated_at/, body)
    #           end
    #         end
    # 
    #         should "not generate migration file" do
    #           assert Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").empty?
    #         end
    #       end
    # 
    #       context "generator with attribute specified" do
    #         rails_generator :scaffy, "recipe", "zippo:string"
    # 
    #         should "use specified attribute" do
    #           assert_generated_file "app/views/recipes/_form.html.haml" do |body|
    #             assert_match "<%= f.text_field :zippo %>", body
    #           end
    #         end
    #       end
    #     end
    # 
    #     context "with test dir" do
    #       setup do
    #         Dir.mkdir("#{RAILS_ROOT}/test") unless File.exists?("#{RAILS_ROOT}/test")
    #       end
    # 
    #       teardown do
    #         FileUtils.rm_rf "#{RAILS_ROOT}/test"
    #       end
    # 
    #       context "generator with some attributes" do
    #         rails_generator :scaffy, "line_item", "name:string", "description:text"
    # 
    #         should_generate_file "test/unit/line_item_test.rb"
    # 
    #         should "have controller tests for each action" do
    #           assert_generated_file "test/functional/line_items_controller_test.rb" do |body|
    #             assert_match "get :index", body
    #             assert_match "get :show", body
    #             assert_match "get :new", body
    #             assert_match "get :edit", body
    #             assert_match "post :create", body
    #             assert_match "put :update", body
    #             assert_match "delete :destroy", body
    #           end
    #         end
    # 
    #         should "have fixture with attributes" do
    #           assert_generated_file "test/fixtures/line_items.yml" do |body|
    #             assert_match "name: MyString", body
    #             assert_match "description: MyText", body
    #           end
    #         end
    #       end
    # 
    #       context "generator with new and index actions" do
    #         rails_generator :scaffy, "line_item", "new", "index"
    # 
    #         should "have controller test with only mentioned actions" do
    #           assert_generated_file "test/functional/line_items_controller_test.rb" do |body|
    #             assert_match "get :index", body
    #             assert_match "get :new", body
    #             assert_match "post :create", body
    #             assert_no_match(/get :show/, body)
    #             assert_no_match(/get :edit/, body)
    #             assert_no_match(/put :update/, body)
    #             assert_no_match(/delete :destroy/, body)
    #           end
    #         end
    # 
    #         should "redirect to index action on successful create" do
    #           assert_generated_file "test/functional/line_items_controller_test.rb" do |body|
    #             assert_match "assert_redirected_to line_items_url", body
    #           end
    #         end
    #       end
    # 
    #       context "generator with edit and index actions" do
    #         rails_generator :scaffy_generator, "line_item", "edit", "index"
    # 
    #         should "redirect to index action on successful update" do
    #           assert_generated_file "test/functional/line_items_controller_test.rb" do |body|
    #             assert_match "assert_redirected_to line_items_url", body
    #           end
    #         end
    #       end
    # 
    


    # end


  end
end

# just an example model we can use
class Recipe < ActiveRecord::Base
  add_column :id, :integer
  add_column :foo, :string
  add_column :bar, :string
  add_column :book_id, :integer
  add_column :created_at, :datetime
  add_column :updated_at, :datetime
end
