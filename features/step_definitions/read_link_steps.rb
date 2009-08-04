Given /the following popular links exist:/ do |links_table|
  links_table.hashes.each do |hash|
    @tag = Tag.find_or_create_by_name(hash[:tag])
    @tag.links.create(:url => hash[:link], :title => hash[:title], :created_at => 1.days.ago)
  end
end

And /I should see:/ do |links_table|
  links_table.hashes.each do |hash|
    Then "I should see \"#{hash[:tag]}\""
    Then "I should see \"#{hash[:link]}\""
  end
end