require "test/test_helper"

class Admin::TableHelperTest < ActiveSupport::TestCase

  include Admin::TableHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end
  def raw(*args); args; end

  setup do
    default_url_options[:host] = "test.host"
  end

=begin

  # FIXME
  def test_build_table

    @current_user = Factory(:typus_user)

    params = { :controller => 'admin/typus_users', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)

    fields = TypusUser.typus_fields_for(:list)
    items = TypusUser.find(:all)

    expects(:render).once.with('admin/helpers/table_header',
      { :headers => [
        '<a href="http://test.host/admin/typus_users?order_by=email">Email </a>',
        '<a href="http://test.host/admin/typus_users?order_by=role">Role </a>',
        '<a href="http://test.host/admin/typus_users?order_by=status">Status </a>',
        '&nbsp;',
        '&nbsp;'
    ]})

    build_table(TypusUser, fields, items)

  end

=end

=begin

  def test_table_header

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index" }
    self.expects(:params).at_least_once.returns(params)

    output = table_header(TypusUser, fields)
    expected = [ "admin/helpers/table_header",
                 { :headers=> [ %(<a href="http://test.host/admin/typus_users?order_by=email">Email</a>),
                                %(<a href="http://test.host/admin/typus_users?order_by=role">Role</a>),
                                %(<a href="http://test.host/admin/typus_users?order_by=status">Status</a>),
                                "&nbsp;"] } ]

    assert_equal expected, output

  end

=end

=begin

  def test_table_header_with_params

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index", :search => "admin" }
    self.expects(:params).at_least_once.returns(params)

    output = table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email&search=admin">Email</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=role&search=admin">Role</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=status&search=admin">Status</a>),
                                 %(&nbsp;) ] } ]

    assert_equal expected, output

  end

=end

=begin

  def test_table_header_when_user_cannot_delete_items

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index" }
    self.expects(:params).at_least_once.returns(params)

    output = table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email">Email</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=role">Role</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=status">Status</a>) ] } ]

    assert_equal expected, output

  end

=end

=begin

  def test_table_header_when_user_cannot_delete_items_with_params

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index", :search => "admin" }
    self.expects(:params).at_least_once.returns(params)

    output = table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email&search=admin">Email</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=role&search=admin">Role</a>),
                                 %(<a href="http://test.host/admin/typus_users?order_by=status&search=admin">Status</a>) ] } ]
    assert_equal expected, output

  end

=end

=begin

  def test_table_belongs_to_field

    @current_user = Factory(:typus_user)

    comment = comments(:without_post_id)
    output = table_belongs_to_field("post", comment)
    expected = "<td></td>"

    assert_equal expected, output
    default_url_options[:host] = "test.host"

    comment = comments(:with_post_id)
    output = table_belongs_to_field("post", comment)
    expected = %(<td><a href="http://test.host/admin/posts/edit/1">Post#1</a></td>)

    assert_equal expected.strip, output

  end

=end

=begin

  def test_table_has_and_belongs_to_many_field
    post = Factory(:post)

    output = table_has_and_belongs_to_many_field("comments", post)
    expected = %(<td>John, Me, Me</td>)

    assert_equal expected.strip, output
  end

=end

  should "test_table_string_field" do
    post = Factory(:post)

    output = table_string_field(:title, post, :created_at)
    expected = %(<td class="title">#{post.title}</td>)

    assert_equal expected.strip, output
  end

  should "test_table_string_field_with_link" do
    post = Factory(:post)

    output = table_string_field(:title, post, :title)
    expected = %(<td class="title">#{post.title}</td>)

    assert_equal expected.strip, output
  end

  should "table_tree_field_when_displays_a_parent" do
    page = Factory(:page)

    output = table_tree_field("test", page)
    expected = "<td>&#151;</td>"

    assert_equal expected, output
  end

  should "table_tree_field_when_displays_a_children" do
    page = Factory(:page, :status => "unpublished")

    output = table_tree_field("test", page)
    expected = "<td>&#151;</td>"

    assert_equal expected, output
  end

  should "test_table_datetime_field" do
    post = Factory(:post)
    Time::DATE_FORMATS[:post_short] = "%m/%y"

    output = table_datetime_field(:created_at, post)
    expected = %(<td>#{post.created_at.strftime("%m/%y")}</td>)

    assert_equal expected.strip, output
  end

  should "test_table_datetime_field_with_link" do
    post = Factory(:post)
    Time::DATE_FORMATS[:post_short] = "%m/%y"

    output = table_datetime_field(:created_at, post, :created_at)
    expected = %(<td>#{post.created_at.strftime("%m/%y")}</td>)

    assert_equal expected.strip, output
  end

=begin

  # FIXME: NameError: undefined local variable or method `controller' for
  def test_table_boolean_field

    post = Factory(:typus_user)
    output = table_boolean_field("status", post)
    expected = <<-HTML
<td><a href="http://test.host/admin/typus_users/toggle/1?field=status" onclick="return confirm('Change status?');">Active</a></td>
    HTML

    assert_equal expected.strip, output

    post = Factory(:typus_user, :status => false)
    output = table_boolean_field("status", post)
    expected = <<-HTML
<td><a href="http://test.host/admin/typus_users/toggle/3?field=status" onclick="return confirm('Change status?');">Inactive</a></td>
    HTML

    assert_equal expected.strip, output

  end

=end

end
