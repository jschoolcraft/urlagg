require "test/test_helper"

class Admin::AssetsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @post = Factory(:post)
  end

  should "verify polymorphic relationship message" do
    get :new, { :back_to => "/admin/posts/#{@post.id}/edit",
                :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash' do
      assert_select 'p', "You're adding a new Asset to Post. Do you want to cancel it?"
      assert_select 'a', "Do you want to cancel it?"
    end
  end

  should "create a polymorphic relationship" do
    assert_difference('post_.assets.count') do
      post :create, { :back_to => "/admin/posts/edit/#{@post.id}",
                      :resource => @post.class.name,
                      :resource_id => @post.id }
    end

    assert_response :redirect
    assert_redirected_to '/admin/posts/edit/1#assets'
    assert_equal "Asset successfully assigned to Post.", flash[:notice]
  end

  should "render edit and verify message on polymorphic relationship" do
    asset = Factory(:asset)

    get :edit, { :id => asset.id,
                 :back_to => "/admin/posts/#{@post.id}/edit",
                 :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash' do
      assert_select 'p', "You're updating a Asset for Post. Do you want to cancel it?"
      assert_select 'a', "Do you want to cancel it?"
    end
  end

  should "return to back_to url" do
    Typus::Resource.expects(:action_after_save).returns(:edit)
    asset = assets(:first)

    post :update, { :back_to => "/admin/posts/#{@post.id}/edit",
                    :resource => @post.class.name,
                    :resource_id => @post.id,
                    :id => asset.id }

    assert_response :redirect
    assert_redirected_to '/admin/posts/1/edit#assets'
    assert_equal "Asset successfully updated.", flash[:notice]
  end

end
