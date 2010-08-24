class Admin::AccountController < AdminController

  layout 'admin/session'

  skip_before_filter :reload_config_and_roles
  skip_before_filter :set_preferences
  skip_before_filter :authenticate

  before_filter :sign_in?, :except => [:forgot_password, :show]
  before_filter :new?, :only => [:forgot_password]

  def new
    flash[:notice] = _("Enter your email below to create the first user.")
  end

  def create
    user = Typus.user_class.generate(:email => params[:typus_user][:email])
    user.status = true
    redirect_to (user.save ? { :action => "show", :id => user.token } : { :action => :new })
  end

  def forgot_password
    return unless request.post?

    if user = Typus.user_class.find_by_email(params[:typus_user][:email])
      url = admin_account_url(user.token)
      Admin::Mailer.reset_password_link(user, url).deliver
      notice = _("Password recovery link sent to your email.")
      path = new_admin_session_path
    else
      render :action => :forgot_password and return
    end

    redirect_to path, :notice => notice
  end

  def show
    flash[:notice] = _("Please set a new password.")
    typus_user = Typus.user_class.find_by_token!(params[:id])
    session[:typus_user_id] = typus_user.id
    redirect_to :controller => "admin/#{Typus.user_class.to_resource}", :action => "edit", :id => typus_user.id
  end

  private

  def sign_in?
    redirect_to new_admin_session_path unless Typus.user_class.count.zero?
  end

  def new?
    redirect_to new_admin_account_path if Typus.user_class.count.zero?
  end

end
