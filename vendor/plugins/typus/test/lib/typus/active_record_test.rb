require "test/test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  should "verify model fields is an instance of active support ordered hash" do
    assert TypusUser.model_fields.instance_of?(ActiveSupport::OrderedHash)
  end

  should "return model fields for TypusUser" do
    expected_fields = [[:id, :integer],
                       [:first_name, :string],
                       [:last_name, :string],
                       [:role, :string],
                       [:email, :string],
                       [:status, :boolean],
                       [:token, :string],
                       [:salt, :string],
                       [:crypted_password, :string],
                       [:preferences, :string],
                       [:created_at, :datetime],
                       [:updated_at, :datetime]]
    assert_equal expected_fields.map { |i| i.first }, TypusUser.model_fields.keys
    assert_equal expected_fields.map { |i| i.last }, TypusUser.model_fields.values
  end

  should "return model fields for post" do
    expected_fields = [[:id, :integer],
                       [:title, :string],
                       [:body, :text],
                       [:status, :string],
                       [:favorite_comment_id, :integer],
                       [:created_at, :datetime],
                       [:updated_at, :datetime],
                       [:published_at, :datetime],
                       [:typus_user_id, :integer]]
    assert_equal expected_fields.map { |i| i.first }, Post.model_fields.keys
    assert_equal expected_fields.map { |i| i.last }, Post.model_fields.values
  end

  should "verify_model_relationships_is_an_instance_of_active_support_ordered_hash" do
    assert TypusUser.model_relationships.instance_of?(ActiveSupport::OrderedHash)
  end

  should "return_model_relationships_for_post" do
    expected = [[:comments, :has_many],
                [:categories, :has_and_belongs_to_many],
                [:user, nil],
                [:assets, :has_many]]
    expected.each do |i|
      assert_equal i.last, Post.model_relationships[i.first]
    end
  end

  should "return_description_of_a_model" do
    assert_equal "System Users Administration", TypusUser.typus_description
  end

  context "Typus fields for" do

    should "verify typus_fields_for accepts strings" do
      assert_equal %w( email role status ), TypusUser.typus_fields_for("list").keys
    end

    should "verify typus_fields_for accepts symbols" do
      assert_equal %w( email role status ), TypusUser.typus_fields_for(:list).keys
    end

    should "return_typus_fields_for_list_for_typus_user" do
      expected_fields = [["email", :string],
                         ["role", :selector],
                         ["status", :boolean]]
      assert_equal expected_fields.map { |i| i.first }, TypusUser.typus_fields_for(:list).keys
      assert_equal expected_fields.map { |i| i.last }, TypusUser.typus_fields_for(:list).values
    end

    should "return_typus_fields_for_form_for_typus_user" do
      expected_fields = [["first_name", :string],
                         ["last_name", :string],
                         ["role", :selector],
                         ["email", :string],
                         ["password", :password],
                         ["password_confirmation", :password],
                         ["language", :selector]]
      assert_equal expected_fields.map { |i| i.first }, TypusUser.typus_fields_for(:form).keys
      assert_equal expected_fields.map { |i| i.last }, TypusUser.typus_fields_for(:form).values
    end

    should "return_typus_fields_for_form_for_picture" do
      expected_fields = [["title", :string],
                         ["picture", :file]]
      assert_equal expected_fields.map { |i| i.first }, Picture.typus_fields_for(:form).keys
      assert_equal expected_fields.map { |i| i.last }, Picture.typus_fields_for(:form).values
    end

    should "return_typus_fields_for_a_model_without_configuration" do
      assert Class.new(ActiveRecord::Base).typus_fields_for(:form).empty?
    end

    should "return_typus_fields_for_relationship_for_typus_user" do
      assert_equal %w( first_name last_name role email language), TypusUser.typus_fields_for(:relationship).keys
    end

    should "return_all_fields_for_undefined_field_type_on_typus_user" do
      assert_equal %w( first_name last_name role email language), TypusUser.typus_fields_for(:undefined).keys
    end

  end

  context "Typus filters" do

    should "return_filters_for_typus_user" do
      expected = [["status", :boolean], ["role", :string]]

      assert_equal expected.map { |i| i.first }.join(", "), Typus::Configuration.config["TypusUser"]["filters"]
      assert_equal expected.map { |i| i.first }, TypusUser.typus_filters.keys
      assert_equal expected.map { |i| i.last }, TypusUser.typus_filters.values
    end

    should "return_post_typus_filters" do
      expected = [["status", :string], ["created_at", :datetime]]
      assert_equal expected.map { |i| i.first }.join(", "), Typus::Configuration.config["Post"]["filters"]
      assert_equal expected.map { |i| i.first }, Post.typus_filters.keys
      assert_equal expected.map { |i| i.last }, Post.typus_filters.values
    end

  end

  context "Typus actions on" do

    should "verify typus_actions_on accepts strings" do
      assert_equal %w( cleanup ), Post.typus_actions_on("index")
    end

    should "verify typus_actions_on accepts symbols" do
      assert_equal %w( cleanup ), Post.typus_actions_on(:index)
    end

    should "return_actions_on_list_for_typus_user" do
      assert TypusUser.typus_actions_on(:list).empty?
    end

    should "return Post actions on edit" do
      assert_equal %w( send_as_newsletter preview ), Post.typus_actions_on(:edit)
    end

    should "return Post actions" do
      assert_equal %w( cleanup preview send_as_newsletter ), Post.typus_actions.sort
    end

  end

  context "Typus options for" do

    should "verify typus_options_for accepts strings" do
      assert_equal 15, Post.typus_options_for("form_rows")
    end

    should "verify typus_options_for accepts symbols" do
      assert_equal 15, Post.typus_options_for(:form_rows)
    end

    should "verify typus_options_for returns nil when options doesnt exist" do
      assert TypusUser.typus_options_for(:unexisting).nil?
    end

    should "return options for post and page" do
      assert_equal 15, Post.typus_options_for(:form_rows)
      assert_equal 25, Page.typus_options_for(:form_rows)
    end

  end

  context "Typus field options for" do

    should "verify on models" do
      assert_equal [ :status ], Post.typus_field_options_for(:selectors)
      assert_equal [ :permalink ], Post.typus_field_options_for(:read_only)
      assert_equal [ :created_at ], Post.typus_field_options_for(:auto_generated)
    end

  end

  context "Typus boolean" do

    should "verify_typus_boolean_is_an_instance_of_active_support_ordered_hash" do
      assert TypusUser.typus_boolean("status").instance_of?(ActiveSupport::OrderedHash)
    end

    should "verify typus_boolean accepts strings" do
      assert_equal [ :true, :false ], TypusUser.typus_boolean("status").keys
    end

    should "verify typus_boolean accepts symbols" do
      assert_equal [ :true, :false ], TypusUser.typus_boolean(:status).keys
    end

    should "return_booleans_for_typus_users" do
      assert_equal [ :true, :false ], TypusUser.typus_boolean(:status).keys
      assert_equal [ "Active", "Inactive" ], TypusUser.typus_boolean(:status).values
    end

    should "return_booleans_for_post" do
      assert_equal [ :true, :false ], Post.typus_boolean(:status).keys
      assert_equal [ "True", "False" ], Post.typus_boolean(:status).values
    end

  end

  context "Typus date format" do

    should "verify typus_date_format accepts strings and symbols" do
      assert_equal :db, Post.typus_date_format("unknown")
      assert_equal :db, Post.typus_date_format(:unknown)
    end

    should "return typus_date_formats for Post" do
      assert_equal :db, Post.typus_date_format
      assert_equal :post_short, Post.typus_date_format("created_at")
      assert_equal :post_short, Post.typus_date_format(:created_at)
    end

  end

  context "Typus defaults for" do

    should "verify typus_defaults_for on Model accepts strings and symbols" do
      assert_equal %w( title ), Post.typus_defaults_for("search")
      assert_equal %w( title ), Post.typus_defaults_for(:search)
    end

    should "return defaults_for search on Post" do
      assert_equal %w( title ), Post.typus_defaults_for(:search)
    end

    should "return default_for relationships on Post" do
      assert_equal %w( assets categories comments views ), Post.typus_defaults_for(:relationships)
      assert !Post.typus_defaults_for(:relationships).empty?
    end

  end

  context "Typus order by" do

    should "return defaults_for order_by on Post" do
      assert_equal "posts.title ASC, posts.created_at DESC", Post.typus_order_by
      assert_equal %w( title -created_at ), Post.typus_defaults_for(:order_by)
    end

  end

  context "Build conditions" do

    should "return_sql_conditions_on_search_for_typus_user" do
      expected = "(role LIKE '%francesc%' OR last_name LIKE '%francesc%' OR email LIKE '%francesc%' OR first_name LIKE '%francesc%')"
      params = { :search => "francesc" }
      assert_equal expected, TypusUser.build_conditions(params).first
      params = { :search => "Francesc" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_search_and_filter_for_typus_user" do

      case ENV["DB"]
      when /mysql/
        boolean_true = "(`typus_users`.`status` = 1)"
        boolean_false = "(`typus_users`.`status` = 0)"
      else
        boolean_true = "(\"typus_users\".\"status\" = 't')"
        boolean_false = "(\"typus_users\".\"status\" = 'f')"
      end

      expected = "((role LIKE '%francesc%' OR last_name LIKE '%francesc%' OR email LIKE '%francesc%' OR first_name LIKE '%francesc%')) AND #{boolean_true}"
      params = { :search => "francesc", :status => "true" }
      assert_equal expected, TypusUser.build_conditions(params).first
      params = { :search => "francesc", :status => "false" }
      assert_match /#{boolean_false}/, TypusUser.build_conditions(params).first

    end

    should "return_sql_conditions_on_filtering_typus_users_by_status" do

      case ENV["DB"]
      when /mysql/
        boolean_true = "(`typus_users`.`status` = 1)"
        boolean_false = "(`typus_users`.`status` = 0)"
      else
        boolean_true = "(\"typus_users\".\"status\" = 't')"
        boolean_false = "(\"typus_users\".\"status\" = 'f')"
      end

      params = { :status => "true" }
      assert_equal boolean_true, TypusUser.build_conditions(params).first
      params = { :status => "false" }
      assert_equal boolean_false, TypusUser.build_conditions(params).first

    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at today" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(created_at BETWEEN E'#{Time.new.midnight.to_s(:db)}' AND E'#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 else
                   "(created_at BETWEEN '#{Time.new.midnight.to_s(:db)}' AND '#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 end
      params = { :created_at => "today" }

      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_few_days" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(created_at BETWEEN E'#{3.days.ago.midnight.to_s(:db)}' AND E'#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 else
                   "(created_at BETWEEN '#{3.days.ago.midnight.to_s(:db)}' AND '#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 end

      params = { :created_at => "last_few_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_7_days" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(created_at BETWEEN E'#{6.days.ago.midnight.to_s(:db)}' AND E'#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 else
                   "(created_at BETWEEN '#{6.days.ago.midnight.to_s(:db)}' AND '#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 end

      params = { :created_at => "last_7_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_30_days" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(created_at BETWEEN E'#{Time.new.midnight.prev_month.to_s(:db)}' AND E'#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 else
                   "(created_at BETWEEN '#{Time.new.midnight.prev_month.to_s(:db)}' AND '#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 end
      params = { :created_at => "last_30_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_posts_by_published_at today" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(published_at BETWEEN E'#{Time.new.midnight.to_s(:db)}' AND E'#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 else
                   "(published_at BETWEEN '#{Time.new.midnight.to_s(:db)}' AND '#{Time.new.midnight.tomorrow.to_s(:db)}')"
                 end

      params = { :published_at => "today" }
      assert_equal expected, Post.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_posts_by_string" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(\"typus_users\".\"role\" = E'admin')"
                 when /mysql/
                   "(`typus_users`.`role` = 'admin')"
                 else
                   "(\"typus_users\".\"role\" = 'admin')"
                 end

      params = { :role => "admin" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

  end

  context "Class methods" do

    should "verify typus_user_id exists on Post" do
      assert Post.typus_user_id?
    end

    should "verify typus_user_id does not exist on Post" do
      assert !TypusUser.typus_user_id?
    end

  end

end
