require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  context "Admin" do

    setup do
      @admin = Factory(:typus_user)
      @request.session[:typus_user_id] = @admin.id
    end

    should "add a category" do
      assert @admin.can?("create", "Post")
    end

    should "destroy a post" do
      get :destroy, { :id => Factory(:post).id, :method => :delete }

      assert_response :redirect
      assert_equal "Post successfully removed.", flash[:notice]
      assert_redirected_to :action => :index
    end

  end

  context "Designer" do

    setup do
      @designer = Factory(:typus_user, :role => "designer")
      @request.session[:typus_user_id] = @designer.id
    end

    should "not_allow_designer_to_add_a_post" do
      get :new

      assert_response :redirect
      assert_equal "Designer can't perform action. (new)", flash[:notice]
      assert_redirected_to :action => :index
    end

    should "not_allow_designer_to_destroy_a_post" do
      get :destroy, { :id => Factory(:post).id, :method => :delete }

      assert_response :redirect
      assert_equal "Designer can't delete this item.", flash[:notice]
      assert_redirected_to :action => :index

    end

  end

end
