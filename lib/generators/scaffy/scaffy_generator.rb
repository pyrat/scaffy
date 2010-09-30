require 'rails/generators/active_record'

class ScaffyGenerator < Rails::Generators::NamedBase

  include Rails::Generators::Migration


  source_root File.expand_path('../templates', __FILE__)

  # make it a class option
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  class_option :namespace, :type => :string, :default => '', :desc => "Specify a namespace"


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
    if options[:namespace].present?
      # add namespace route
      route "namespace :#{namespace.downcase} {resources :#{object_plural}}"
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
    template "test/shoulda/model_test.rb", "test/unit/#{object_singular}.rb"
    template "test/shoulda/controller_test.rb", "test/functional" +  namespace_directory +  "/#{object_plural}_controller_test.rb"
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
    namespace_prefix + name.capitalize.pluralize + 'Controller'
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
      namespace.downcase + "/"
    else
      ''
    end
  end

  def controller_filename
    object_plural + '_controller'
  end

  def show_url
    if options[:namespace].present?
      "[:#{namespace.downcase}, #{object_singular}]"
    else
      object_singular
    end
  end


  def new_url
    if namespace.present?
      "polymorphic_url([:#{namespace.downcase}, #{object_singular}], :action => :new)"
    else
      "polymorphic_url(#{object_singular}, :action => :new)"
    end
  end

  def edit_url
    if namespace.present?
      "polymorphic_url([:#{namespace.downcase}, #{object_singular}], :action => :edit)"
    else
      "polymorphic_url(#{object_singular}, :action => :edit)"
    end
  end

  def human_name
    name.capitalize.pluralize
  end


end
