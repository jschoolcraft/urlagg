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
  end
end
