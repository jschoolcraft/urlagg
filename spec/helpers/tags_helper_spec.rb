require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(TagsHelper)
  end
  
  it "extracts the host from the URL" do
    helper.extract_host("http://urlagg.com/some/path").should == 'urlagg.com'
  end
  
  it "renders nothing on exception" do
    helper.extract_host(nil).should == ''
  end
end
