require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  describe "POST /accounts/create" do
    it "should deliver the welcome email" do
      @user = Factory.stub(:user, :login => "john",  :email => 'john@example.com', :password => "secret", :password_confirmation => "secret")
      post :create, :user => {:login => @user.login, :email => @user.email, :password => @user.password, :password_confirmation => @user.password_confirmation}
    end
  end
end
