class Admin::SuperUserSessionsController < Admin::Base
  skip_before_filter :require_super_user, :only => [:new, :create]
  before_filter :require_no_super_user, :only => [:create]

  def new
    if current_super_user_session
      redirect_to admin_dashboard_path
    else
      @super_user_session = SuperUserSession.new
    end
  end

  def create
    @super_user_session = SuperUserSession.new(params[:super_user_session])
    if @super_user_session.save
      redirect_to admin_dashboard_url
    else
      flash.now[:error] = 'Login failed'
      render :action => :new
    end
  end
  
  def destroy
    current_super_user_session.destroy
    redirect_to root_url
  end
end
