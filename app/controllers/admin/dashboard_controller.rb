class Admin::DashboardController < Admin::Base
  # @users_day = User.count(:all, :conditions => ['created_at between ? and ?', 1.day.ago, Time.now])
  # @users_week = User.count(:all, :conditions => ['created_at between ? and ?', 1.week.ago, Time.now])
  # @users_month = User.count(:all, :conditions => ['created_at between ? and ?', 1.month.ago, Time.now])
  # @users_year = User.count(:all, :conditions => ['created_at between ? and ?', 1.year.ago, Time.now])
  
  def index
    render
  end
end