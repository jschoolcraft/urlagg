ENV["RAILS_ENV"] = 'test'

require 'rubygems'
require 'spork'

Spork.prefork do
  require File.dirname(__FILE__) + "/../config/environment"
  require 'spec/autorun'
  require 'spec/rails'
  require 'webrat'
  require 'remarkable_rails'
  require "email_spec/helpers"
  require "email_spec/matchers"

  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

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
end

Spork.each_run do
  Spec::Runner.configure do |config|
    def login(session_stubs = {}, user_stubs = {})
      UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
    end

    def logout
      @user_session = nil
    end
  end
end
