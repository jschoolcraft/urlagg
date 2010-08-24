class Admin::DashboardController < AdminController

  def show
    raise "Run `rails generate typus` to create configuration files." if Typus.applications.empty?
  end

end
