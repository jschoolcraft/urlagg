class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:create]
  before_filter :require_user, :only => :destroy
  
  def new
    if current_user_session
      redirect_to tags_path
    else
      @user_session = UserSession.new
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default tags_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Successfully logged out"
    redirect_back_or_default new_user_session_url
  end
end
