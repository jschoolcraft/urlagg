class Admin::SessionController < AdminController

  skip_before_filter :reload_config_and_roles
  skip_before_filter :set_preferences
  skip_before_filter :authenticate

  before_filter :create_an_account?, :except => [:destroy]

  def new
  end

  def create
    user = Typus.user_class.authenticate(params[:typus_user][:email], params[:typus_user][:password])

    if user
      session[:typus_user_id] = user.id
      path = params[:back_to] || admin_dashboard_path
    else
      alert = _("The email and/or password you entered is invalid.")
      path = new_admin_session_path(:back_to => params[:back_to])
    end

    redirect_to path, :alert => alert
  end

  def destroy
    session[:typus_user_id] = nil
    I18n.locale = I18n.default_locale
    redirect_to :action => :new
  end

  private

  def create_an_account?
    redirect_to new_admin_account_path if Typus.user_class.count.zero?
  end

end
