require "test/test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

=begin

  # FIXME: Pending to verify the applications included. Use the keys.
  should "render applications" do
    @current_user = Factory(:typus_user)

    output = applications
    partial = "admin/helpers/dashboard/applications"
    options = { :applications => { [ "Site", [ "Asset", "Page" ] ] => nil,
                                   [ "System", [ "Delayed::Task" ] ] => nil,
                                   [ "Blog", [ "Comment", "Post" ] ] => nil,
                                   [ "Typus", [ "TypusUser" ] ] => nil } }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

=end

  should "render resources" do
    @current_user = Factory(:typus_user)

    output = resources
    partial = "admin/helpers/dashboard/resources"
    options = { :resources => ["Git", "Status", "WatchDog"] }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

end
