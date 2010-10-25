require 'rails/generators/active_record'

class ScaffyGenerator < Rails::Generators::NamedBase

  include Rails::Generators::Migration


  source_root File.expand_path('../templates', __FILE__)

  # make it a class option
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  class_option :namespace, :type => :string, :default => '', :desc => "Specify a namespace"
  class_option :layout, :type => :string, :desc => "Generate a layout and styles"


  def render_controller
    template "controller.rb", "app/controllers" + namespace_directory + "/#{controller_filename}.rb"
  end

  def render_views
    %w(_form index new show).each do |t|
      template "views/haml/#{t}.html.haml", "app/views" + namespace_directory + "/#{object_plural}/#{t}.html.haml"
    end
  end

  def render_helper
    template "helper.rb", "app/helpers/#{object_plural}_helper.rb"
  end

  def add_routes
    if namespace.present?
      # add namespace route
      route "namespace :#{namespace.downcase} do \n resources :#{object_plural} \nend"
    else
      # add standard route
      route "resources :#{object_plural}"
    end
  end

  def render_migration
    migration_template "migration.rb", "db/migrate/create_#{object_plural}.rb"
  end

  def render_model
    template "model.rb", "app/models/#{object_singular}.rb"
  end

  def render_tests
    # need to create factories directory if it doesnt exist?
    template "test/factory_girl/factory.rb", "test/factories/#{object_singular}.rb"
    template "test/shoulda/model_test.rb", "test/unit/#{object_singular}_test.rb"
    template "test/shoulda/controller_test.rb", "test/functional" +  namespace_directory +  "/#{object_plural}_controller_test.rb"
  end
  
  def render_layout
    if options[:layout]
      copy_file "views/haml/layout.html.haml", "app/views/layouts/application.html.haml"
      copy_file "assets/stylesheets/scaffy.css", "public/stylesheets/scaffy.css"
      copy_file "assets/images/alertbad_icon.gif", "public/images/scaffy/alertbad_icon.gif"
      copy_file "assets/images/alertgood_icon.gif", "public/images/scaffy/alertgood_icon.gif"
      copy_file "assets/images/glossy-error-icon.jpg", "public/images/scaffy/glossy-error-icon.gif"
      
      inject_into_module "app/helpers/application_helper.rb", ApplicationHelper do
        %(
        # Returns a div for each key passed if there's a flash
        # with that key
        def flash_div *keys
          divs = keys.select { |k| flash[k] }.collect do |k|
            content_tag :div, flash[k], :class => "flash " + k.to_s
          end
          divs.join.html_safe
        end
        )
      end
      
    end
  end
  
  def remove_index
    remove_file "public/index.html"
  end
  
  def add_gems
    gem 'haml'
    gem 'shoulda', :env => :test
    gem 'factory_girl_rails', :env => :test
  end

  protected
  
  class << self
    
    def next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
    
  end
  
  
  def namespace
    options[:namespace]
  end

  def controller_name
    namespace_prefix + name.capitalize.pluralize
  end

  def namespace_prefix
    unless options[:namespace].blank?
      namespace.capitalize + "::"
    else
      ''
    end
  end

  def namespace_directory
    unless options[:namespace].blank?
      "/" + namespace.downcase
    else
      ''
    end
  end

  def object_singular
    name.downcase
  end

  def object_plural
    name.downcase.pluralize
  end

  def class_name
    name.capitalize
  end

  def index_url
    namespace_url_prefix + object_plural + "_url"
  end

  def namespace_url_prefix
    if namespace.present?
      namespace.downcase + "_"
    else
      ''
    end
  end

  def controller_filename
    object_plural + '_controller'
  end

  def show_url(options = {})
    val = options[:instance] ? "@" : ''
    if namespace.present?
      "[:#{namespace.downcase}, #{val}#{object_singular}]"
    else
      val + object_singular
    end
  end


  def new_url
    if namespace.present?
      "polymorphic_url([:#{namespace.downcase}, #{class_name}.new], :action => :new)"
    else
      "polymorphic_url(#{class_name}.new, :action => :new)"
    end
  end

  def edit_url(options = {})
    val = options[:instance] ? "@" : ''
    if namespace.present?
      "polymorphic_url([:#{namespace.downcase}, #{val}#{object_singular}], :action => :edit)"
    else
      "polymorphic_url(#{val}#{object_singular}, :action => :edit)"
    end
  end

  def human_name
    name.capitalize.pluralize
  end
  
  def inject_into_module(path, mod, *args, &block)
    config = args.last.is_a?(Hash) ? args.pop : {}
    config.merge!(:after => /module #{mod}\n|module #{mod} .*\n/)
    inject_into_file(path, *(args << config), &block)
  end


end
