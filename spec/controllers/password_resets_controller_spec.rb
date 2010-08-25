require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe "POST /password_resets/create" do
    it "should deliver the password reset instructions email" do
      # expect
      @user = Factory.create(:registered_user)
      Notifier.should_receive(:password_reset_instructions).with(@user).and_return(mock("mailer", :deliver => nil))
      # when
      post :create, :email => @user.email
    end

    it "should display the form again if email not found" do
      User.should_receive(:find_by_email).with("not-a-valid-email@example.com").and_return(nil)
      post :create, :email => 'not-a-valid-email@example.com'
      response.should render_template('new')
    end
  end

  describe "PUT /password_resets/update" do

    def do_action(params={})
      put :update, {:id => "1"}.merge(params)
    end

    before(:each) do
      @user = mock_model(User)
      User.stub!(:find).and_return(@user)
    end

    it "should update the password attributes" do
      @user.should_receive(:update_password_attributes).with("some password params")
      do_action(:user => "some password params")
    end

    describe "failed update" do

      before(:each) do
        @user.stub!(:update_password_attributes).and_return(false)
      end

      it "should render edit" do
        do_action
        response.should render_template(:edit)
      end

      it "should flash notice" do
        do_action
        flash[:notice].should_not be_nil
      end
    end

    describe "successful update" do

      before(:each) do
        @user.stub!(:update_password_attributes).and_return(true)
      end

      it "should redirect" do
        do_action
        response.should redirect_to(account_url)
      end
    end
  end
end