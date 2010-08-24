require "test/test_helper"

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @first_category = Factory(:category, :position => 1)
    @second_category = Factory(:category, :position => 2)
  end

  should "verify referer" do
    get :position, { :id => @first_category.id, :go => 'move_lower' }
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
  end

  should "position item one step down" do
    get :position, { :id => @first_category.id, :go => 'move_lower' }

    assert_equal "Record moved lower.", flash[:notice]
    assert_equal 2, @first_category.reload.position
    assert_equal 1, @second_category.reload.position
  end

  should "position item one step up" do
    get :position, { :id => @second_category.id, :go => 'move_higher' }

    assert_equal "Record moved higher.", flash[:notice]
    assert_equal 2, @first_category.reload.position
    assert_equal 1, @second_category.reload.position
  end

  should "position top item to bottom" do
    get :position, { :id => @first_category.id, :go => 'move_to_bottom' }
    assert_equal "Record moved to bottom.", flash[:notice]
    assert_equal 2, @first_category.reload.position
  end

  should "position bottom item to top" do
    get :position, { :id => @second_category.id, :go => 'move_to_top' }
    assert_equal "Record moved to top.", flash[:notice]
    assert_equal 1, @second_category.reload.position
  end

end
