require "test/test_helper"

class RoutesTest < ActiveSupport::TestCase

  setup do
    @routes = Rails.application.routes.routes.map(&:name)
  end

  should "verify admin routes" do
    expected = %w(admin)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "verify admin dashboard routes" do
    expected = %w(admin_dashboard)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "verify admin account named routes" do
    expected = %w(forgot_password_admin_account admin_account_index new_admin_account admin_account)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "verify admin session named routes" do
    expected = %w(new_admin_session admin_session)
    expected.each { |r| assert @routes.include?(r) }
  end

end
