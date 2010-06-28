require 'remarkable/active_record'
require "email_spec"

require 'factory_girl'

Dir[File.expand_path(File.dirname(__FILE__) + "/../factories/*.rb")].each {|f| require f}

RSpec.configure do |config|
  def login(session_stubs = {}, user_stubs = {})
    UserSession.stub(:find).and_return(user_session(session_stubs, user_stubs))
  end

  def logout
    @user_session = nil
  end

  def current_user(stubs = {})
    @current_user ||= stub_model(User, stubs)
  end

  def user_session(stubs = {}, user_stubs = {})
    @current_user_session ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
  end

  # super_user admin
  def current_super_user(stubs = {})
    @current_super_user ||= stub_model(SuperUser, stubs)
  end

  def super_user_session(stubs = {}, user_stubs = {})
    @current_super_user_session ||= mock_model(SuperUserSession, {:super_user => current_super_user(user_stubs)}.merge(stubs))
  end

  def admin_login(session_stubs = {}, user_stubs = {})
    SuperUserSession.stub!(:find).and_return(super_user_session(session_stubs, user_stubs))
  end

  def admin_logout
    @super_user_session = nil
  end
end
