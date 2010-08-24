module Typus

  module Authentication

    protected

    #--
    # Require login checks if the user is logged on Typus, otherwise
    # is sent to the sign in page with a :back_to param to return where
    # she tried to go.
    #++
    def authenticate
      case Typus.authentication
      when :none
        authenticate_via_none
      when :http_basic
        authenticate_via_http_basic
      when :session
        authenticate_via_session
      end
    end

    def authenticate_via_none
      @current_user = Admin::FakeUser.new
    end

    def authenticate_via_http_basic
      @current_user = Admin::FakeUser.new
      authenticate_or_request_with_http_basic(Typus.admin_title) do |user_name, password|
        user_name == Typus.username && password == Typus.password
      end
    end

    def authenticate_via_session
      if session[:typus_user_id]
        current_user
      else
        back_to = request.env['PATH_INFO'] unless [admin_dashboard_path, admin_path].include?(request.env['PATH_INFO'])
        redirect_to new_admin_session_path(:back_to => back_to)
      end
    end

    #--
    # Return the current user. If role does not longer exist on the
    # system @current_user will be signed out from Typus.
    #++
    def current_user

      @current_user = Typus.user_class.find(session[:typus_user_id])

      unless Typus::Configuration.roles.has_key?(@current_user.role)
        raise _("Role does no longer exists.")
      end

      unless @current_user.status
        back_to = (request.env['REQUEST_URI'] == admin_dashboard_path) ? nil : request.env['REQUEST_URI']
        raise _("Typus user has been disabled.")
      end

      I18n.locale = @current_user.preferences[:locale]

    rescue Exception => error
      flash[:notice] = error.message
      session[:typus_user_id] = nil
      redirect_to new_admin_session_path(:back_to => back_to)
    end

    #--
    # Action is available on: edit, update, toggle and destroy
    #++
    def check_if_user_can_perform_action_on_user

      return unless Typus.authentication.eql?(:session)

      return unless @item.kind_of?(Typus.user_class)

      current_user = (@current_user == @item)

      message = case params[:action]
                when 'edit'

                  # Only admin and owner of Typus User can edit.
                  if @current_user.is_not_root? && !current_user
                    _("As you're not the admin or the owner of this record you cannot edit it.")
                  end

                when 'update'

                  # current_user cannot change her role.
                  if current_user && !(@item.role == params[@object_name][:role])
                    _("You can't change your role.")
                  end

                when 'toggle'

                  # Only admin can toggle typus user status, but not herself.
                  if @current_user.is_root? && current_user
                    _("You can't toggle your status.")
                  elsif @current_user.is_not_root?
                    _("You're not allowed to toggle status.")
                  end

                when 'destroy'

                  # Admin can remove anything except herself.
                  if @current_user.is_root? && current_user
                    _("You can't remove yourself.")
                  elsif @current_user.is_not_root?
                    _("You're not allowed to remove Typus Users.")
                  end

                end

      if message
        flash[:notice] = message
        redirect_to set_path
      end

    end

    #--
    # This method checks if the user can perform the requested action.
    # It works on models, so its available on the admin_controller.
    #++
    def check_if_user_can_perform_action_on_resources

      return unless Typus.authentication.eql?(:session)

      message = case params[:action]
                when 'index', 'show'
                  "%{current_user_role} can't display items."
                when 'destroy'
                  "%{current_user_role} can't delete this item."
                else
                  "%{current_user_role} can't perform action. (%{action})"
                end

      message = _(message,
                  :current_user_role => @current_user.role.capitalize,
                  :action => params[:action])

      unless @current_user.can?(params[:action], @resource)
        flash[:notice] = message
        redirect_to set_path
      end

    end

    #--
    # This method checks if the user can perform the requested action.
    # It works on a resource: git, memcached, syslog ...
    #++
    def check_if_user_can_perform_action_on_resource
      return unless Typus.authentication.eql?(:session)

      controller = params[:controller].extract_resource
      action = params[:action]
      unless @current_user.can?(action, controller.camelize, { :special => true })
        render :text => "Not allowed!", :status => :unprocessable_entity
      end
    end

    #--
    # If item is owned by another user, we only can perform a
    # show action on the item. Updated item is also blocked.
    #
    #   before_filter :check_resource_ownership, :only => [ :edit, :update, :destroy,
    #                                                       :toggle, :position,
    #                                                       :relate, :unrelate ]
    #++
    def check_resource_ownership

      return unless Typus.authentication.eql?(:session)

      # By-pass if current_user is root.
      return if @current_user.is_root?

      condition_typus_users = @item.respond_to?(Typus.relationship) && !@item.send(Typus.relationship).include?(@current_user)
      condition_typus_user_id = @item.respond_to?(Typus.user_fk) && !@item.owned_by?(@current_user)

      if condition_typus_users || condition_typus_user_id
         alert = _("You don't have permission to access this item.")
         redirect_to set_path, :alert => alert
      end

    end

    def check_resource_ownerships

      return unless Typus.authentication.eql?(:session)

      # By-pass if current_user is root.
      return if @current_user.is_root?

      # Show only related items it @resource has a foreign_key (Typus.user_fk)
      # related to the logged user.
      if @resource.typus_user_id?
        condition = { Typus.user_fk => @current_user }
        @conditions = @resource.merge_conditions(@conditions, condition)
      end

    end

    def check_ownership_of_referal_item
      return unless Typus.authentication.eql?(:session)

      return unless params[:resource] && params[:resource_id]
      klass = params[:resource].classify.constantize
      return if !klass.typus_user_id?
      item = klass.find(params[:resource_id])
      raise "You're not owner of this record." unless item.owned_by?(@current_user) || @current_user.is_root?
    end

    def set_attributes_on_create
      return unless Typus.authentication.eql?(:session)
      if @resource.typus_user_id?
        @item.attributes = { Typus.user_fk => @current_user.id }
      end
    end

    def set_attributes_on_update
      return unless Typus.authentication.eql?(:session)
      if @resource.typus_user_id? && @current_user.is_not_root?
        @item.update_attributes(Typus.user_fk => @current_user.id)
      end
    end

    #--
    # Reload @current_user when updating to see flash message in the
    # correct locale.
    #++
    def reload_locales
      return unless Typus.authentication.eql?(:session)
      if @resource.eql?(Typus.user_class)
        I18n.locale = @current_user.reload.preferences[:locale]
      end
    end

  end

end
