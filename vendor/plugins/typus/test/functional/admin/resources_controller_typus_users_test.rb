require "test/test_helper"

class Admin::TypusUsersControllerTest < ActionController::TestCase

  context "Master role" do

    setup do
      Typus.master_role = 'admin'
      @typus_user = Factory(:typus_user)
      @typus_user_editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @request.session[:typus_user_id] = @typus_user.id
      @request.env['HTTP_REFERER'] = '/admin/typus_users'
    end

    should "allow_admin_to_create_typus_users" do
      get :new
      assert_response :success
    end

    should "not allow admin to toogle her status" do
      get :toggle, { :id => @typus_user.id, :field => 'status' }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You can't toggle your status.", flash[:notice]
    end

    should "allow_admin_to_toggle_other_users_status" do

      get :toggle, { :id => @typus_user_editor.id, :field => 'status' }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Typus user status changed.", flash[:notice]
    end

    should "not be able to destroy herself" do
      assert_difference('TypusUser.count', 0) do
        delete :destroy, :id => @typus_user.id
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You can't remove yourself.", flash[:notice]
    end

    should "verify_admin_can_destroy_others" do
      assert_difference('TypusUser.count', -1) do
        delete :destroy, :id => @typus_user_editor.id
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Typus user successfully removed.", flash[:notice]
    end

  end

  context "No master role" do

    setup do
      @typus_user = Factory(:typus_user, :role => "editor")
      @request.session[:typus_user_id] = @typus_user.id
      @request.env['HTTP_REFERER'] = '/admin/typus_users'
    end

    should "not_allow_non_root_typus_user_to_toggle_status" do
      get :toggle, { :id => @typus_user.id, :field => 'status' }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You're not allowed to toggle status.", flash[:notice]
    end

    should "not_allow_editor_to_create_typus_users" do
      get :new

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Editor can't perform action. (new)", flash[:notice].to_s
    end

  end

  context "Editor" do

    setup do
      @request.env['HTTP_REFERER'] = '/admin/typus_users'
      @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @request.session[:typus_user_id] = @typus_user.id
    end

    should "allow_editor_to_update_himself" do
      post :update, { :id => @typus_user.id, :typus_user => { :role => 'editor' } }

      assert_response :redirect
      assert_redirected_to "/admin/typus_users/edit/#{@typus_user.id}"
      assert_equal "Typus user successfully updated.", flash[:notice]
    end

    should "not_allow_editor_to_update_himself_to_become_admin" do
      post :update, { :id => @typus_user.id, :typus_user => { :role => 'admin' } }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You can't change your role.", flash[:notice]
    end

    should "not_allow_editor_to_edit_other_users_profiles" do
      get :edit, { :id => Factory(:typus_user).id }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "As you're not the admin or the owner of this record you cannot edit it.", flash[:notice]
    end

    should "not_allow_editor_to_destroy_users" do
      delete :destroy, :id => Factory(:typus_user).id

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You're not allowed to remove Typus Users.", flash[:notice]
    end

    should "not_allow_editor_to_destroy_herself" do
      delete :destroy, :id => @typus_user.id

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You're not allowed to remove Typus Users.", flash[:notice]
    end

    should "change_root_to_editor_so_editor_can_edit_others_content" do
      Typus.expects(:master_role).at_least_once.returns("editor")
      get :edit, { :id => Factory(:typus_user).id }
      assert_response :success
    end

  end

  context "Designer" do

    setup do
      @request.env['HTTP_REFERER'] = '/admin'
      @typus_user = Factory(:typus_user, :role => "designer")
      @request.session[:typus_user_id] = @typus_user.id
    end

    should "redirect_to_admin_dashboard_if_user_does_not_have_privileges" do
      get :index

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Designer can't display items.", flash[:notice]
    end

  end

end