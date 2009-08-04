require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SuperUserSessionsController do
  
  describe "/new" do
    def do_get
      get :new
    end
    describe "not logged in" do
      it "creates a new super_user_session and assigns it for the view" do
        SuperUserSession.should_receive(:find).and_return(super_user_session)
        do_get
        assigns[:current_super_user_session].should == super_user_session
      end
    
      it "should renders the admin new template if not logged in" do
        do_get
        response.should render_template('new')
      end
    end
    
    describe "logged in" do    
      before(:each) do
        admin_login
      end
      
      it "redirects to the admin dashboard if already logged in" do
        do_get
        response.should redirect_to(admin_dashboard_path)
      end
    end
    
  end

  describe "post create" do
    before(:each) do
      SuperUserSession.stub!(:find).and_return(nil)
      @super_session = mock_model(SuperUserSession, :save => true)
      SuperUserSession.stub!(:new).and_return(@super_session)
    end
    
    def do_post
      post :create, :super_user_session => { 'login' => 'username', 'password' => 'password'}
    end
    
    it "builds a new super_user_session from params and assigns it for the view" do
      SuperUserSession.should_receive(:new).with('login' => 'username', 'password' => 'password').and_return(@super_session)
      do_post
      assigns[:super_user_session].should == @super_session
    end
    
    it "redirects to the admin dashboard if save succeeds" do
      @super_session.should_receive(:save).and_return(true)
      do_post
      response.should redirect_to admin_dashboard_path
    end
    
    it "re-renders the admin login form if save fails and assigns the flash" do
      @super_session.should_receive(:save).and_return(false)
      do_post
      response.should render_template('new')
    end
  end

  describe "delete destroy" do
    before do
      admin_login
      super_user_session.stub!(:destroy)
    end
    
    def do_delete
      delete :destroy
    end
    
    it "destroys the current super_user session" do
      super_user_session.should_receive(:destroy)
      do_delete
    end
    
    it "redirects to the root_url" do
      do_delete
      response.should redirect_to(root_url)
    end
  end

end