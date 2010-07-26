Given /^the tag "([^\"]*)" has (\d+) popular links$/ do |tag, number|
  @tag = Tag.find_by_name(tag)
  1.upto(number.to_i) do |i|
    @tag.links << Factory.create(:link, { :title => "Link ##{i} for tag #{tag}" })
  end
end

Then /^I should see links (\d+)-(\d+) for "([^\"]*)"$/ do |first, last, tag|
  limit = last.to_i - first.to_i + 1
  Link.find(:all, :limit => limit, :offset => first.to_i-1).each do |link|
    Then "I should see \"#{link.title}\""
  end
end

Then /^I should not see links (\d+)-(\d+) for "([^\"]*)"$/ do |first, last, tag|
  limit = last.to_i - first.to_i + 1
  Link.find(:all, :limit => limit, :offset => first.to_i-1).each do |link|
    Then "I should not see \"#{link.title}\""
  end
end

Then /^I should see a link with title "([^\"]*)" under the tag heading "([^\"]*)"$/ do |title, tag_name|
  tag = Tag.find_by_name(tag_name)
  with_scope("#tag_#{tag.id}.tag") do
    page.should have_xpath("//h3", :text => tag_name)
    page.should have_xpath("//li/a", :text => title)
  end
end

When /^I follow "([^\"]*)" for tag "([^\"]*)"$/ do |title, tag_name|
  tag = Tag.find_by_name(tag_name)
  click_link("mark_read_tag_#{tag.id}")
end

Then /^I should see pagination controls$/ do
  page.should have_css("div.pagination")
end