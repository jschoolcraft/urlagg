module Admin

  module DashboardHelper

    def applications
      apps = {}

      Typus.models.each do |model|
        # Get the application name.
        app_name = model.constantize.typus_application
        # Initialize the application if needed.
        apps[app_name] = [] unless apps.keys.include?(app_name)
        # Add model to the application only if the @current_user has permission.
        apps[app_name] << model if @current_user.resources.include?(model)
      end

      render File.join(path, "applications"), :applications => apps.compact.sort
    end

    def resources
      available = Typus.resources.map do |resource|
                    resource if @current_user.resources.include?(resource)
                  end.compact

      return if available.empty?

      render File.join(path, "resources"), :resources => available
    end

    private

    def path
      "admin/helpers/dashboard"
    end

  end

end
