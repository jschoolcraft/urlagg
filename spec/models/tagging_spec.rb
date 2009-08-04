require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
  should_belong_to :tag, :counter_cache => true
  should_belong_to :user
  
  should_have_column :last_seen_at, :type => :datetime
end
