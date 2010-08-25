class Notifier < ActionMailer::Base
  default :from => "support@urlagg.com"
  
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email, :subject => "Password Reset Instructions")
  end
end