require "typus/authentication"

class AdminController < ActionController::Base

  unloadable

  before_filter :reload_config_and_roles
  before_filter :authenticate

  def show
    redirect_to admin_dashboard_path
  end

  protected

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  include Typus::Authentication

  def set_path
    @back_to || request.referer || admin_dashboard_path
  end

end
