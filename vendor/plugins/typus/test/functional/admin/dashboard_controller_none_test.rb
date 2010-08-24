require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  context "When authentication is none" do

    setup do
      Typus.stubs(:authentication).returns(:none)
    end

    should "render dashboard" do
      get :show
      assert_response :success
    end

  end

end
