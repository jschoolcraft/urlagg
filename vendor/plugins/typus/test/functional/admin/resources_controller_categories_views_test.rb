require "test/test_helper"

class Admin::CategoriesControllerTest < ActionController::TestCase

  should "verify form partial can overwrited by model" do
    get :new
    assert_match "categories#_form.html.erb", @response.body
  end

end
