Given /^"([^\"]*)" is tracking tags "([^\"]*)"$/ do |name, tags|
  user = User.find_by_login(name)
  tags.split(', ').each_with_index do |tag, index|
    new_tag = user.track_tag(tag)
    new_tag.taggings.find(:first, :order => 'created_at DESC').update_attributes(:created_at => index.hours.ago)
  end
end

Given /^the tag "([^\"]*)" has popular link "([^\"]*)" with title "([^\"]*)"$/ do |tag, link, title|
  @tag = Tag.find_or_create_by_name(tag)
  @tag.links.create!(:url => link, :title => title, :bookmarks => Link.threshold + 1)
end


Given /^the tag "([^\"]*)" has popular link "([^\"]*)" with title "([^\"]*)" and "([^\"]*)"$/ do |tag, link, title, source_tags|
  @tag = Tag.find_or_create_by_name(tag)
  link = @tag.links.create!(:url => link, :title => title, :source_tags => source_tags.split(/,\s+/), :bookmarks => Link.threshold + 1)
end

Given /^the following tracked tags with popular links$/ do |table|
  table.hashes.each do |hash|
    @tag = Tag.find_or_create_by_name(hash["tag"])
    @link = @tag.links.create!(
      :url => hash["link"], :title => hash["title"], :created_at => (hash["days_ago"]).to_i.days.ago, :bookmarks => Link.threshold + 1)
  end
end

Given /^there are links for the tag "([^\"]*)"$/ do |tag|
  @tag = Tag.find_or_create_by_name(tag)
  add_links_to_tag(@tag, 5)
end

Given /^the following users, tracking tags, with lots of links$/ do |table|
  table.hashes.each do |hash|
    @user = Factory.create(:user, :login => hash["user"])
    hash["tags"].split(",").each_with_index do |tag, index|
      @tag = @user.track_tag(tag)
      @tag.taggings.find(:first, :order => 'created_at DESC').update_attributes(:created_at => index.hours.ago)
      if @tag.links.count == 0
        add_links_to_tag(@tag, 12)
      end
    end
  end
end

Given /^the following users, tracking tags, with one link$/ do |table|
  table.hashes.each do |hash|
    @user = Factory.create(:user, :login => hash["user"])
    hash["tags"].split(",").each do |tag|
      @tag = @user.track_tag(tag)
      if @tag.links.count == 0
        add_links_to_tag(@tag, 1)
      end
    end
  end
end

Then /^I should see tags "([^\"]*)" in my sidebar under "([^\"]*)"$/ do |tags, heading|
  with_scope("#sidebar div.section") do
    page.should have_css("h3", :text => heading)
    tags.split(/,\s*/).each do |tag|
      page.should have_css("li a", :text => tag)
    end
  end
end

def add_links_to_tag(tag, num)
  1.upto(num) do |i|
    link = Factory.create(:link, :title => "Link-#{i}-for-tag", :created_at => i.minutes.ago, :bookmarks => Link.threshold + 1)
    tag.links << link
    link.source_tags = ["foo", "bar"]
  end
end