require "test/test_helper"

class Admin::ResourcesHelperTest < ActiveSupport::TestCase

  include Admin::ResourcesHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def render(*args); args; end

  should "verify display_link_to_previous" do
    @resource = Post
    params = { :action => "edit", :back_to => "/back_to_param" }
    self.expects(:params).at_least_once.returns(params)

    partial = "admin/helpers/resources/display_link_to_previous"
    options = { :message => "You're updating a Post." }

    assert_equal [ partial, options ], display_link_to_previous
  end

  should "remove_filter_link" do
    output = remove_filter_link("")
    assert output.nil?
  end

  context "Build list" do

    setup do
      @model = TypusUser
      @fields = %w( email role status )
      @items = TypusUser.all
      @resource = "typus_users"
    end

    should "verify build_list_when_returns_a_table" do
      self.stubs(:build_table).returns("a_list_with_items")
      output = build_list(@model, @fields, @items, @resource)
      assert_equal "a_list_with_items", output
    end

    should "verify build_list_when_returns_a_template" do
      self.stubs(:render).returns("a_template")
      File.stubs(:exist?).returns(true)
      output = build_list(@model, @fields, @items, @resource)
      assert_equal "a_template", output
    end

  end

end
