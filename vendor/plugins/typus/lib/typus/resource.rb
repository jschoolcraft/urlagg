module Typus

  module Resource

    # Setup Typus::Resource. This should be run from an initializer.
    #
    #     Typus::Resource.setup do |config|
    #       config.default_action_on_item = "index"
    #     end
    #
    def self.setup
      yield self
    end

    # Defines the default_action_on_item.
    mattr_accessor :default_action_on_item
    @@default_action_on_item = "edit"

    # Defines the end_year.
    mattr_accessor :end_year
    @@end_year = nil

    # Defines the form_rows.
    mattr_accessor :form_rows
    @@form_rows = 15

    # Defines the action_after_save.
    mattr_accessor :action_after_save
    @@action_after_save = "edit"

    # Defines the minute step.
    mattr_accessor :minute_step
    @@minute_step = 5

    # Defines nil.
    mattr_accessor :human_nil
    @@human_nil = "nil"

    # Defines only_user_items.
    mattr_accessor :only_user_items
    @@only_user_items = false

    # Defines per_page
    mattr_accessor :per_page
    @@per_page = 15

    # Defines start year
    mattr_accessor :start_year
    @@start_year = nil

    def self.method_missing(*args)
      nil
    end

  end

end
