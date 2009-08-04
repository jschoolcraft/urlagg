namespace :cron do
  desc "fetch popular links from delicious for tracked tags"
  task :fetch_popular_links => :environment do
    TaggedLink.fetch_links_for_all_tags
  end
    
  desc "generate xml sitemap"
  task :sitemap => :environment do
    if_production = Rails.env == 'production'

    live_options = {
      :ping_google => if_production,
      :gzip        => if_production
    }

    sitemap = BigSitemap.new({:url_options => {:host => 'urlagg.com'}}.merge(live_options))
    sitemap.add(Tag, { :change_frequency => 'hourly', :priority => 0.5 })
    sitemap.generate  
  end

  desc "fetch popular links, generate sitemap and ping search engines"
  task :fetch_generate_ping => :environment do
    Rake::Task["cron:fetch_popular_links"].invoke
    Rake::Task["cron:sitemap"].invoke
  end
end