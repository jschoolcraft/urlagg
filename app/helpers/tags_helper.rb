module TagsHelper
  def extract_host(url)
    begin
      extracted_url = URI.extract(url)
      URI.parse(extracted_url.first).host
    rescue StandardError => e
      HoptoadNotifier.notify(:error_message => e)
      ''
    end
  end
  
  def render_links_for_tags(taggings)
    taggings.sort! do |a, b|
      a.tag.name <=> b.tag.name
    end
    
    result = []
    taggings.each do |tagging|
      tag = tagging.tag
      time = [current_user.last_viewed_tags_index_at || 100.years.ago, tagging.last_seen_at || 100.years.ago].max
      links = tag.links_after(time)
      result << render(:partial => tag, :locals => { :links => links }) unless links.empty?
    end
    
    if result.empty?
      content_tag(:div, "Sorry, we haven't found any updated links for the tags you are tracking.", { :class => 'notice' })
    else
      result.join
    end.html_safe
  end
end
