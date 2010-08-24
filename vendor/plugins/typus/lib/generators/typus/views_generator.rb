module Typus

  module Generators

    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app/views", __FILE__)

      desc <<-MSG
Description:
  Copies all Typus views to your application.

      MSG

      def copy_views
        directory "admin", "app/views/admin"
      end

      def copy_layouts
        directory "layouts", "app/views/layouts"
      end

    end

  end

end
