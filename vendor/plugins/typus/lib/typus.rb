# coding: utf-8

module Typus

  # Define the application name.
  mattr_accessor :admin_title
  @@admin_title = "Typus"

  # Define a subtitle
  mattr_accessor :admin_sub_title
  @@admin_sub_title = <<-CODE
<a href="http://core.typuscms.com/">typus</a> by <a href="http://intraducibles.com">intraducibles.com</a>
  CODE

  # Authentication mechanism: none, basic, advanced
  mattr_accessor :authentication
  @@authentication = :none

  # Define the configuration folder.
  mattr_accessor :config_folder
  @@config_folder = "config/typus"

  # Define the username
  mattr_accessor :username
  @@username = "admin"

  # Define the password: Used as a default password and for the http
  # authentication.
  mattr_accessor :password
  @@password = "columbia"

  # Configure the e-mail address which will be shown in Admin::Mailer.
  mattr_accessor :mailer_sender
  @@mailer_sender = nil

  # Define the file preview.
  mattr_accessor :file_preview
  @@file_preview = :medium

  # Define the file thumbnail.
  mattr_accessor :file_thumbnail
  @@file_thumbnail = :thumb

  # Defines the default relationship table.
  mattr_accessor :relationship
  @@relationship = "typus_users"

  # Defines the default master role.
  mattr_accessor :master_role
  @@master_role = "admin"

  # Defines the default user_class_name.
  mattr_accessor :user_class_name
  @@user_class_name = "TypusUser"

  # Defines the default user_fk.
  mattr_accessor :user_fk
  @@user_fk = "typus_user_id"

  mattr_accessor :available_locales
  @@available_locales = [:en]

  class << self

    # Default way to setup typus. Run rails generate typus to create
    # a fresh initializer with all configuration values.
    def setup
      yield self
    end

    def root
      (File.dirname(__FILE__) + "/../").chomp("/lib/../")
    end

    def applications
      Typus::Configuration.config.collect { |i| i.last["application"] }.compact.uniq.sort
    end

    # Lists modules of an application.
    def application(name)
      Typus::Configuration.config.collect { |i| i.first if i.last["application"] == name }.compact.uniq.sort
    end

    # Lists models from the configuration file.
    def models
      Typus::Configuration.config.map { |i| i.first }.sort
    end

    # Lists resources, which are tableless models.
    def resources
      Typus::Configuration.roles.keys.map do |key|
        Typus::Configuration.roles[key].keys
      end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
    end

    # Lists models under <tt>app/models</tt>.
    def detect_application_models
      model_dir = Rails.root.join("app/models")
      Dir.chdir(model_dir) do
        models = Dir["**/*.rb"]
      end
    end

    def locales
      human = available_locales.map { |i| locales_mapping[i.to_s] }
      available_locales.map { |i| i.to_s }.to_hash_with(human)
    end

    def locales_mapping
      mapping = { "ca" => "Català",
                  "de" => "German",
                  "en" => "English",
                  "es" => "Español",
                  "fr" => "Français",
                  "hu" => "Magyar",
                  "pt-BR" => "Portuguese",
                  "ru" => "Russian" }
      mapping.default = "Unknown"
      return mapping
    end

    def detect_locales
      available_locales.each do |locale|
        I18n.load_path += Dir[File.join(Typus.root, "config", "available_locales", "#{locale}*")]
      end
    end

    def application_models
      detect_application_models.map do |model|
        class_name = model.sub(/\.rb$/,"").camelize
        klass = class_name.split("::").inject(Object) { |klass,part| klass.const_get(part) }
        class_name if klass < ActiveRecord::Base && !klass.abstract_class?
      end.compact
    end

    def user_class
      user_class_name.constantize
    end

    def reload!
      Typus::Configuration.roles!
      Typus::Configuration.config!
      detect_locales
    end

    def boot!

      # Support extensions
      require "support/active_record"
      require "support/array"
      require "support/hash"
      require "support/object"
      require "support/string"

      # Typus configuration and resources configuration
      require "typus/configuration"
      require "typus/resource"

      # Typus Active Record extensions and mixins
      require "typus/orm/active_record"
      require "typus/user"

      # Vendor
      require "vendor/paginator"

    end

  end

end
