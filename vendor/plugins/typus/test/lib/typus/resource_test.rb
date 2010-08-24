require "test/test_helper"

class ResourceTest < ActiveSupport::TestCase

  should "verify default resource configuration options" do
    assert_equal "edit", Typus::Resource.default_action_on_item
    assert Typus::Resource.end_year.nil?
    assert_equal 15, Typus::Resource.form_rows
    assert_equal "edit", Typus::Resource.action_after_save
    assert_equal 5, Typus::Resource.minute_step
    assert_equal "nil", Typus::Resource.human_nil
    assert !Typus::Resource.only_user_items
    assert_equal 15, Typus::Resource.per_page
    assert Typus::Resource.start_year.nil?
  end

end
