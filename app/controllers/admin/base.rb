class Admin::Base < ApplicationController
  before_filter :require_super_user
  
  protected
  
  def current_super_user
    return @current_super_user if defined?(@current_super_user)
    @current_super_user = current_super_user_session && current_super_user_session.super_user
  end
  
  def require_super_user
    unless current_super_user
      redirect_to root_url
      return false
    end
  end
  
  def require_no_super_user
  end
  
  def current_super_user_session
    return @current_super_user_session if defined?(@current_super_user_session)
    @current_super_user_session = SuperUserSession.find
  end
end