require File.dirname(__FILE__) + '/../spec_helper'

describe TaggedLink do
  describe "fetches popular links for all tracked tags" do
    before do
      @tags = (1..5).map { |i| mock_model(Tag, :name => "tag-#{i}") }
    end

    it "should call fetch_and_create... for each tag" do
      Tag.should_receive(:find).with(:all).and_return(@tags)
      @tags.each do |tag|
        TaggedLink.should_receive(:fetch_and_create_tagged_links_for_tag).with(tag).and_return(nil)
        TaggedLink.should_not_receive(:fetch_and_create_recent_links_for_tag).with(tag).and_return(nil)
      end
      TaggedLink.fetch_links_for_all_tags
    end
  end

  describe "parsing a link" do
    before do
      @json = {"d"=>"Remember The Milk: Online to do list and task management",
          "dt"=>"2005-10-11T19:28:10Z",
          "t"=>["tool", "productivity"],
          "u"=>"http://www.rememberthemilk.com/"}
    end

    it "assigns attributes" do
      @link = TaggedLink.parse_json_link(@json)
      @link.class.should == Link
      @link.title.should == "Remember The Milk: Online to do list and task management"
      @link.url.should == "http://www.rememberthemilk.com/"
      @link.source_tags.should == ["tool", "productivity"]
    end
  end

  describe "#fetch_and_create_tagged_links_for_tag" do
    before do
      @tag = Factory.create(:tag, :name => 'gtd')
      @tag.tagged_links.stub!(:find_by_link_id).and_return(nil)

      @json_file = open(File.join(Rails.root, '/spec/fixtures/delicious/gtd.json'))
      @json = open(File.join(Rails.root, '/spec/fixtures/delicious/gtd.json')).read

      TaggedLink.stub!(:open).and_return(@json_file)

      @parsed_response = (1..5).map { |i|  {"u" => "http://link-#{i}-for-tag-#{@tag.name}.com", "t" => ["source-tag-#{i}-for-link-#{i}", "source-tag-#{i+1}-for-link-#{i+1}"]} }
      JSON.stub!(:parse).and_return(@parsed_response)
    end

    it "should fetch the json feed for the tag" do
      url = "http://feeds.delicious.com/v2/json/popular/gtd?count=30"
      TaggedLink.should_receive(:open).with(url).and_return(@json_file)
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should escape the tag name to deal with special characters" do
      url = "http://feeds.delicious.com/v2/json/popular/c%23?count=30"
      TaggedLink.should_receive(:open).with(url).and_return(@json_file)
      TaggedLink.fetch_and_create_tagged_links_for_tag(Factory.create(:tag, :name => 'c#'))
    end

    it "should fetch popular/ for the tag 'popular'" do
      @tag = Factory.create(:tag, :name => 'popular')
      url = "http://feeds.delicious.com/v2/json/popular?count=30"
      TaggedLink.should_receive(:open).with(url).and_return(@json_file)
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should fetch json/ for tag 'hot'" do
      @tag = Factory.create(:tag, :name => 'hot')
      url = "http://feeds.delicious.com/v2/json/?count=30"
      TaggedLink.should_receive(:open).with(url)
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should fetch popular/tag for tag 'hotter'" do
      @tag = Factory.create(:tag, :name => 'hotter')
      url = "http://feeds.delicious.com/v2/json/popular/hotter?count=30"
      TaggedLink.should_receive(:open).with(url)
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should parse the json response" do
      JSON.should_receive(:parse).with(@json).and_return(@parsed_response)
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should build a link for each item in the response" do
      @parsed_response.each do |link|
        TaggedLink.should_receive(:parse_json_link).with(link).and_return(mock_model(Link))
      end
      TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
    end

    it "should not add a duplicate link to the collection" do
      JSON.stub!(:parse).and_return([{ "u" => "http://foo.com", "t" => ["foo", "bar", "baz"] }])
      @tag.tagged_links.should_receive(:find_by_link_id).and_return(@link = Factory.create(:link))
      lambda {
        TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
      }.should_not change(@tag.tagged_links, :count)
    end

    it "should add the fetched link to the tagged links collection if not already there" do
      lambda {
        TaggedLink.fetch_and_create_tagged_links_for_tag(@tag)
      }.should change(@tag.tagged_links, :count).by(5)
    end

  end

  describe "#fetch_and_create_recent_links_for_tag" do
    before do
      @tag = Factory.create(:tag, :name => 'gtd')
      @tag.tagged_links.stub!(:find_by_link_id).and_return(nil)

      @json_file = open(File.join(Rails.root, '/spec/fixtures/delicious/gtd-recent.json'))
      @json = open(File.join(Rails.root, '/spec/fixtures/delicious/gtd-recent.json')).read

      TaggedLink.stub!(:open).and_return(@json_file)

      @parsed_response = (1..5).map { |i|  {"u" => "http://link-#{i}-for-tag-#{@tag.name}.com", "t" => ["source-tag-#{i}-for-link-#{i}", "source-tag-#{i+1}-for-link-#{i+1}"]} }
      JSON.stub!(:parse).and_return(@parsed_response)
    end

    it "should fetch the json feed for the tag" do
      url = "http://feeds.delicious.com/v2/json/tag/gtd"
      TaggedLink.should_receive(:open).with(url).and_return(@json_file)
      TaggedLink.fetch_and_create_recent_links_for_tag(@tag)
    end

    it "should escape the tag name to deal with special characters" do
      url = "http://feeds.delicious.com/v2/json/tag/c%23"
      TaggedLink.should_receive(:open).with(url).and_return(@json_file)
      TaggedLink.fetch_and_create_recent_links_for_tag(Factory.create(:tag, :name => 'c#'))
    end

    it "should parse the json response" do
      JSON.should_receive(:parse).with(@json).and_return(@parsed_response)
      TaggedLink.fetch_and_create_recent_links_for_tag(@tag)
    end

    it "should not add a duplicate link to the collection" do
      JSON.stub!(:parse).and_return([{ "u" => "http://foo.com", "t" => ["foo", "bar", "baz"] }])
      @tag.tagged_links.should_receive(:find_by_link_id).and_return(@link = Factory.create(:link))
      lambda {
        TaggedLink.fetch_and_create_recent_links_for_tag(@tag)
      }.should_not change(@tag.tagged_links, :count)
    end

    it "should build a link for each item in the response" do
      @parsed_response.each do |link|
        TaggedLink.should_receive(:parse_json_link).with(link).and_return(mock_model(Link))
      end
      TaggedLink.fetch_and_create_recent_links_for_tag(@tag)
    end

    it "should add the fetched link to the tagged links collection if not already there" do
      lambda {
        TaggedLink.fetch_and_create_recent_links_for_tag(@tag)
      }.should change(@tag.tagged_links, :count).by(5)
    end
  end
end
