desc "cron for heroku"
task :cron => :environment do
  # fetch links every hour
  fetch_links_for_all_tags
  # generate sitemap
  # generate_xml_sitemap

  # likely want to clean out database daily
  if Time.now.hour == 1
    # clean out the database...
  end
end

def fetch_links_for_all_tags
  TaggedLink.fetch_links_for_all_tags
end

def generate_xml_sitemap
  if_production = Rails.env == 'production'

  live_options = {
    :ping_google => if_production,
    :gzip        => if_production
  }

  sitemap = BigSitemap.new({:url_options => {:host => 'urlagg.com'}}.merge(live_options))
  sitemap.add(Tag, { :change_frequency => 'hourly', :priority => 0.5 })
  sitemap.generate
end
