require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LayoutHelper do
  #Delete this example and add some real ones or delete this file
  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(LayoutHelper)
  end
  
  it "should do..." do
    helper.title('A Title')
    helper.instance_variable_get(:@content_for_title).should == 'A Title'
    helper.title(3)
    helper.instance_variable_get(:@content_for_title).should == '3'
  end
end