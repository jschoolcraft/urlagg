module AdminHelper

  def typus_block(resource = @resource.to_resource, partial = params[:action])
    partials_path = "admin/#{resource}"
    resources_partials_path = "admin/resources"

    partials = ActionController::Base.view_paths.map do |view_path|
      Dir["#{view_path}/#{partials_path}/*"].map { |f| File.basename(f, '.html.erb') }
    end.flatten
    resources_partials = Dir[Rails.root.join("app/views/#{resources_partials_path}/*").to_s].map do |file|
                           File.basename(file, ".html.erb")
                         end

    path = if partials.include?("_#{partial}") then partials_path
           elsif resources_partials.include?(partial) then resources_partials_path
           end

    render "#{path}/#{partial}" if path
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def header
    render "admin/helpers/header"
  end

  def apps
    render "admin/helpers/apps"
  end

  def login_info(user = @current_user)
    return if user.kind_of?(Admin::FakeUser)

    admin_edit_typus_user_path = { :controller => "/admin/#{Typus.user_class.to_resource}",
                                   :action => 'edit',
                                   :id => user.id }

    message = _("Are you sure you want to sign out and end your session?")

    user_details = if user.can?('edit', Typus.user_class_name)
                     link_to user.name, admin_edit_typus_user_path
                   else
                     user.name
                   end

    render "admin/helpers/login_info", :message => message, :user_details => user_details
  end

  def display_flash_message(message = flash)
    return if message.empty?
    render "admin/helpers/flash_message", :flash_type => message.keys.first, :message => message
  end

end
