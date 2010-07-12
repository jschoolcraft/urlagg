require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Emails" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  # include ActionController::UrlWriter

  describe "Password reset email" do
    before(:all) do
      @user = Factory.stub(:registered_user)
      @email = Notifier.create_password_reset_instructions(@user)
      # default_url_options[:host] = "urlagg.com"
    end

    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end

    it "should contain the reset password instructions in the mail body" do
      @email.should have_body_text(/A request to reset your password has been made/)
    end

    it "should contain a link to the password reset link" do
      pending "lost access to UrlWriter" do
        @email.should have_body_text(/#{edit_password_reset_url(@user.perishable_token)}/)
      end
    end

    it "should have the correct subject" do
      @email.should have_subject(/Password Reset Instructions/)
    end
  end
end
