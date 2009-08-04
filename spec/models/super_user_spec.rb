require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SuperUser do
  it { should have_column :login, :email, :crypted_password, :persistence_token, :last_login_ip, :current_login_ip, :type => :string }
  it { should have_column :login_count, :type => :integer }
  it { should have_column :last_request_at, :last_login_at, :current_login_at, :type => :datetime }
end