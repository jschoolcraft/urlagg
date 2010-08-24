require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  context "When authentication is http_basic" do

    setup do
      Typus.stubs(:authentication).returns(:http_basic)
    end

    should "return a 401 message when no credentials sent" do
      get :show
      assert_response 401
    end

    should "authenticate user" do
      @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:columbia")
      get :show
      assert_response :success
    end

  end

end
