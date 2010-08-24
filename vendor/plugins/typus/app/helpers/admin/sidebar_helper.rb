module Admin

  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_application

      Typus.application(app_name).each do |resource|
        next unless @current_user.resources.include?(resource)
        klass = resource.constantize
        resources[resource] = default_actions(klass) + export(klass) + custom_actions(klass)
        resources[resource].compact!
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

    def default_actions(klass)
      actions = []

      if @current_user.can?("create", klass)
        options = { :controller => klass.to_resource }
        message = _("Add new")
        actions << (link_to_unless_current message, options.merge(:action => "new"))
      end

      message = _("List")
      options = { :controller => klass.to_resource }
      actions << (link_to_unless_current message, options)

      return actions
    end

    def custom_actions(klass)
      options = { :controller => klass.to_resource }
      klass.typus_actions_on("index").map do |action|
        if @current_user.can?(action, klass)
          (link_to_unless_current _(action.humanize), options.merge(:action => action))
        end
      end
    end

    def export(klass)
      return [] unless params[:action] == "index"

      klass.typus_export_formats.map do |format|
        link_to _("Export as %{format}", :format => format.upcase), params.merge(:format => format)
      end
    end

 end

end
