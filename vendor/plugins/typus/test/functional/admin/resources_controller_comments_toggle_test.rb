require "test/test_helper"

class Admin::CommentsControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
    @comment = Factory(:comment)
    @request.env['HTTP_REFERER'] = "/admin/comments"
  end

  should "toggle" do
    get :toggle, { :id => @comment.id, :field => "spam" }

    assert_response :redirect
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal "Comment spam changed.", flash[:notice]
    assert @comment.reload.spam
  end

end
