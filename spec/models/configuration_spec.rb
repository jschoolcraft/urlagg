require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Configuration do
  should_have_column :name, :value, :type, :type => :string
  should_have_index :name
  
  before(:each) do
    @value = 1.hour.from_now.to_s
    @config = Configuration.create(:name => 'dont_update_bookmarks_before', :value => @value, :type => 'Time')
  end
  
  describe "dont_update_bookmarks_before" do
    it "fetches the config with name dont_update_bookmarks_before" do
      Configuration.should_receive(:find_by_name).with('dont_update_bookmarks_before').and_return(@config)
      Configuration.dont_update_bookmarks_before
    end
    
    it "if does not find the configuration it returns a time in the past" do
      Configuration.should_receive(:find_by_name).and_return(nil)
      Configuration.dont_update_bookmarks_before.should < Time.now
    end
    
    it "returns a Time" do
      Configuration.dont_update_bookmarks_before.should be_kind_of(Time)
    end
  end
  
  describe "dont_update_bookmarks_before=" do
    before(:each) do
      Configuration.stub!(:find_or_create_by_name).and_return(@config)
    end
    
    it "creates a new config with the name dont_update_bookmarks_before if it does not already exist" do
      Configuration.should_receive(:find_or_create_by_name).with('dont_update_bookmarks_before').and_return(@config)
      Configuration.dont_update_bookmarks_before = 1.hour.from_now
    end
    
    it "updates the value" do
      new_value = 1.hour.from_now
      @config.should_receive(:update_attributes).with(:value => new_value.to_s)
      Configuration.dont_update_bookmarks_before = new_value
    end
  end
end