class ScaffyGenerator < Rails::Generator::Base
  attr_accessor :name, :attributes, :controller_actions

  def initialize(runtime_args, runtime_options = {})
    super
    usage if @args.empty?

    @name = @args.first
    @controller_actions = []
    @attributes = []

    @args[1..-1].each do |arg|
      if arg == '!'
        options[:invert] = true
      elsif arg.include? ':'
        @attributes << Rails::Generator::GeneratedAttribute.new(*arg.split(":"))
      else
        @controller_actions << arg
        @controller_actions << 'create' if arg == 'new'
        @controller_actions << 'update' if arg == 'edit'
      end
    end

    @controller_actions.uniq!
    @attributes.uniq!

    if options[:invert] || @controller_actions.empty?
      @controller_actions = all_actions - @controller_actions
    end

    if @attributes.empty?
      options[:skip_model] = true # default to skipping model if no attributes passed
      if model_exists?
        model_columns_for_attributes.each do |column|
          @attributes << Rails::Generator::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      else
        @attributes << Rails::Generator::GeneratedAttribute.new('name', 'string')
      end
    end
  end

  def manifest
    record do |m|
      unless options[:skip_model]
        m.directory "app/models"
        m.template "model.rb", "app/models/#{singular_name}.rb"
        unless options[:skip_migration]
          m.migration_template "migration.rb", "db/migrate", :migration_file_name => "create_#{migration_name}"
        end

        m.directory "test/unit"
        m.template "tests/testunit/model.rb", "test/unit/#{singular_name}_test.rb"
      end

      unless options[:skip_controller]
        m.directory "app/controllers" + namespace_dir

        m.template "controller.rb", "app/controllers/#{plural_name}_controller.rb"

        m.directory "app/helpers" + namespace_dir
        m.template "helper.rb", "app/helpers/#{plural_name}_helper.rb"

        m.directory "app/views/#{plural_name}"

        controller_actions.each do |action|
          if File.exist? source_path("views/#{view_language}/#{action}.html.#{view_language}")
            m.template "views/#{view_language}/#{action}.html.#{view_language}", "app/views/#{plural_name}/#{action}.html.#{view_language}"
          end
        end

        if form_partial?
          m.template "views/#{view_language}/_form.html.#{view_language}", "app/views/#{plural_name}/_form.html.#{view_language}"
        end

        m.directory "test/functional" + namespace_dir

        # Route resources accordingly.
        if namespace_dir
          m.route_namespace_resources(namespace_dir, migration_name)
        else
          m.route_resources(migration_name)
        end

        m.template "tests/#{test_framework}/controller.rb", "test/functional/#{plural_name}_controller_test.rb"
      end
    end
  end

  def form_partial?
    actions? :new, :edit
  end

  def all_actions
    %w[index show new create edit update destroy]
  end

  def action?(name)
    controller_actions.include? name.to_s
  end

  def actions?(*names)
    names.all? { |n| action? n.to_s }
  end

  # Some helper methods for name generation used in the generator.

  def singular_name
    names = name.underscore.split("/")
    if names.size > 1
      names.last.singularize
    else
      names.first.singularize
    end
  end

  def plural_name
    name.underscore.pluralize
  end

  # A way to simply calculcate the
  # namespace dir.
  def namespace_dir
    names = plural_name.split("/")
    if names.size > 1
      "/" + names.first
    else
      ""
    end
  end

  def class_name
    singular_name.camelize
  end

  def index_name
    plural_name.gsub("/", "_")
  end

  def migration_name
    singular_name.pluralize
  end

  def plural_class_name
    plural_name.camelize
  end


  def controller_methods(dir_name)
    controller_actions.map do |action|
      read_template("#{dir_name}/#{action}.rb")
    end.join("  \n").strip
  end

  def render_form
    if form_partial?
      "= render :partial => 'form'"
    else
      read_template("views/haml/_form.html.haml")
    end
  end

  def item_path(suffix = 'path')
    if action? :show
      "@#{singular_name}"
    else
      "#{plural_name}_#{suffix}"
    end
  end

  def item_path_for_spec(suffix = 'path')
    if action? :show
      "#{singular_name}_#{suffix}(assigns[:#{singular_name}])"
    else
      "#{plural_name}_#{suffix}"
    end
  end

  def item_path_for_test(suffix = 'path')
    if action? :show
      "#{singular_name}_#{suffix}(assigns(:#{singular_name}))"
    else
      "#{plural_name}_#{suffix}"
    end
  end

  def model_columns_for_attributes
    class_name.constantize.columns.reject do |column|
      column.name.to_s =~ /^(id|created_at|updated_at)$/
    end
  end

  protected

  # opportunity to add new languages
  # but happy enough with just haml for the initial release
  def view_language
    'haml'
  end

  def test_framework
    options[:test_framework] ||= :testunit
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-model", "Don't generate a model or migration file.") { |v| options[:skip_model] = v }
    opt.on("--skip-migration", "Don't generate migration file for model.") { |v| options[:skip_migration] = v }
    opt.on("--skip-timestamps", "Don't add timestamps to migration file.") { |v| options[:skip_timestamps] = v }
    opt.on("--skip-controller", "Don't generate controller, helper, or views.") { |v| options[:skip_controller] = v }
    opt.on("--invert", "Generate all controller actions except these mentioned.") { |v| options[:invert] = v }
    opt.on("--testunit", "Use test/unit for test files.") { options[:test_framework] = :testunit }
  end

  # is there a better way to do this? Perhaps with const_defined?
  def model_exists?
    File.exist? destination_path("app/models/#{singular_name}.rb")
  end

  def read_template(relative_path)
    ERB.new(File.read(source_path(relative_path)), nil, '-').result(binding)
  end

  def banner
    <<-EOS
    Creates a controller and optional model given the name, actions, and attributes.

    USAGE: #{$0} #{spec.name} ModelName [controller_actions and model:attributes] [options]
    EOS
  end
end


module Rails
  module Generator
    module Commands

      class Create < Base
        
        
        # Generate namespace resources. (namespace name, resource name, options)
        def route_namespace_resources(namespace_name, resource_name, options = {})
          sentinel = 'ActionController::Routing::Routes.draw do |map|'
          sentinel_existing = "map.namespace :#{namespace_name} do |#{namespace_name}|"

          resource_name = resource_name.to_sym.inspect

          namespace_start = "map.namespace :#{namespace_name} do |#{namespace_name}| \n"
          resource_list = "#{resource_name}, #{options.inspect}"
          namespace_end = "end"

          # Need a way to work out whether this is the second namespace
          # Essentially scan the file for the correct namespace sentinel.

          unless options[:pretend]

            if file_contains('config/routes.rb', /(#{Regexp.escape(sentinel_existing)})/mi)
              gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel_existing)})/mi do |match|
                "#{match}\n #{namespace_name}.resources #{resource_list}\n"
              end
            else
              gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
                "#{match}\n #{namespace_start} #{namespace_name}.resources #{resource_list}\n #{namespace_end}"
              end
            end
          end
        end


        def file_contains(relative_destination, regex)
          path = destination_path(relative_destination)
          File.read(path).match(regex) ? true : false
        end


      end
    end
  end
end
