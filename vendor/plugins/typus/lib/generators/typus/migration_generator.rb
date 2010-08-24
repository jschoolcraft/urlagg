require "rails/generators/migration"

module Typus

  module Generators

    class MigrationGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      Typus.reload!

      class_option :user_class_name, :default => "AdminUser"
      class_option :user_fk, :default => "admin_user_id"

      desc <<-DESC
Description:
  This generator creates required configuration files and a migration to
  enable authentication on the admin panel.

Examples:

  `rails generate typus:migration`

    creates needed files with `AdminUser` as the Typus user.

  `rails generate typus:migration -u User`

    creates needed files with `User` as the Typus user.

      DESC

      def self.next_migration_number(path)
        Time.now.utc.to_s(:number)
      end

      def generate_migration
        migration_template "migration.rb", "db/migrate/create_#{admin_users_table_name}"
      end

      def generate_initializer
        template "config/initializers/typus_migration.rb", "config/initializers/typus_session.rb"
      end

      def generate_models
        template "config/typus/typus.yml", "config/typus/typus.yml"
        template "config/typus/typus_roles.yml", "config/typus/typus_roles.yml"
        template "model.rb", "app/models/#{options[:user_class_name].underscore}.rb"
        template "model.yml", "test/fixtures/#{options[:user_class_name].underscore.pluralize}.yml"
      end

      def generate_controllers
        klass = options[:user_class_name].constantize
        @resource = klass.model_name.pluralize
        template "controller.rb", "app/controllers/admin/#{klass.to_resource}_controller.rb"
        template "functional_test.rb",  "test/functional/admin/#{klass.to_resource}_controller_test.rb"
      end

      protected

      def admin_users_table_name
        options[:user_class_name].tableize
      end

      def configuration
        @configuration
      end

      def inherits_from
        "Admin::ResourcesController"
      end

      def migration_name
        "Create#{options[:user_class_name]}s"
      end

      def resource
        @resource
      end

    end

  end

end
