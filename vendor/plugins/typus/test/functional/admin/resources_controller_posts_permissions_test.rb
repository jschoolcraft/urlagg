require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  context "Root" do

    setup do
      editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @post = Factory(:post, :typus_user => editor)
    end

    should "verify_root_can_edit_any_record" do
      Post.all.each do |post|
        get :edit, { :id => post.id }
        assert_response :success
        assert_template 'edit'
      end
    end

    should "verify_admin_updating_an_item_does_not_change_typus_user_id_if_not_defined" do
      post :update, { :id => @post.id, :post => { :title => 'Updated by admin' } }
      post_updated = Post.find(@post.id)
      assert_equal @post.typus_user_id, post_updated.typus_user_id
    end

    should "verify_admin_updating_an_item_does_change_typus_user_id_to_whatever_admin_wants" do
      post :update, { :id => @post.id, :post => { :title => 'Updated', :typus_user_id => 108 } }
      post_updated = Post.find(@post.id)
      assert_equal 108, post_updated.typus_user_id
    end

  end

  context "No root" do

    setup do
      @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @request.session[:typus_user_id] = @typus_user.id
      assert @typus_user.is_not_root?
      @request.env['HTTP_REFERER'] = '/admin/posts'
    end

    should "verify_editor_can_show_any_record" do
      Post.all.each do |post|
        get :show, { :id => post.id }
        assert_response :success
        assert_template 'show'
      end
    end

    should "verify_editor_tried_to_edit_a_post_owned_by_himself" do
      _post = Factory(:post, :typus_user => @typus_user)
      get :edit, { :id => _post.id }
      assert_response :success
    end

    should "verify_editor_tries_to_edit_a_post_owned_by_the_admin" do
      get :edit, { :id => Factory(:post).id }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You don't have permission to access this item.", flash[:alert]
    end

    should "verify_editor_tries_to_show_a_post_owned_by_the_admin" do
      get :show, { :id => Factory(:post).id }
      assert_response :success
    end

    should "verify_editor_tries_to_show_a_post_owned_by_the_admin whe only user items" do

      Typus::Resource.expects(:only_user_items).returns(true)
      post = Factory(:post)
      get :show, { :id => post.id }

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You don't have permission to access this item.", flash[:alert]
    end

    should "verify_typus_user_id_of_item_when_creating_record" do
      post :create, { :post => { :title => "Chunky Bacon", :body => "Lorem ipsum ..." } }
      post_ = Post.find_by_title("Chunky Bacon")

      assert_equal @request.session[:typus_user_id], post_.typus_user_id
    end

    should "verify_editor_updating_an_item_does_not_change_typus_user_id" do

      [ 108, nil ].each do |typus_user_id|
        _post = Factory(:post, :typus_user => @typus_user)
        post :update, { :id => _post.id, :post => { :title => 'Updated', :typus_user_id => @typus_user.id } }
        post_updated = Post.find(_post.id)
        assert_equal  @request.session[:typus_user_id], post_updated.typus_user_id
      end
    end

  end

end
