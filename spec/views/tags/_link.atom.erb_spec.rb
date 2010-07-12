require File.dirname(__FILE__) + '/../../spec_helper'

describe 'tags/_link.atom.erb' do
  helper(TagsHelper)
  before(:each) do
    @tag = mock_model(Tag, :name => 'tag-title')
    @link = mock_model(Link, :title => "link-title",
        :url => "http://www.example.com",
        :tags => [
          @tag,
          mock_model(Tag, :name => "another_tag_for-link-1"),
          mock_model(Tag, :name => "another_tag_for-link-2")],
        :created_at => 1.hours.ago)
    assign :link, @link
    
    do_render
  end
  
  def do_render
    render :partial => 'tags/link.atom.erb', :locals => {:link => @link, :tag => @tag}
    @content = rendered
  end
  
  it "sets the content properly" do
    pending "have to deal with missing have_tag matcher in rspec-rails" do
      @content.should have_tag('li') do
        with_tag('a', @link.title)
      
        list_of_tags = (@link.tags - [@tag]).map(&:name).join(', ')
      
        with_tag('div.related', /Also seen in: #{Regexp.escape(list_of_tags)}/)
      end    
    end
  end
end
