class TaggedLink < ActiveRecord::Base
  belongs_to :tag
  belongs_to :link

  class << self
    def fetch_links_for_all_tags
      @tags = Tag.find :all
      @tags.each do |tag|
        fetch_and_create_tagged_links_for_tag(tag)
      end
    end

    def fetch_and_create_tagged_links_for_tag(tag)
      special_tags = %w[hot popular]
      if special_tags.include?(tag.name)
        case tag.name
        when /^popular$/
          url = "http://feeds.delicious.com/v2/json/popular?count=30"
        when /^hot$/
          url = "http://feeds.delicious.com/v2/json/?count=30"
        end
      else
        url = "http://feeds.delicious.com/v2/json/popular/#{URI.escape(tag.name)}?count=30"
      end
      json = JSON.parse(open(url).read)

      added_count = 0

      json.each do |item|
        link = parse_json_link(item)
        unless tag.tagged_links.find_by_link_id(link.id)
          added_count += 1
          tag.links << link
        end
      end
    end

    def parse_json_link(attributes)
      a = map_attributes(attributes)
      unless link = Link.find_by_url(attributes["u"])
        link = Link.create(a)
      end
      link
    end

    private
      def map_attributes(attributes)
        delicious_mapping = {
          "u" => :url,
          "d" => :title,
          "t" => :source_tags
        }

        ret = {}
        attributes.each do |k, v|
          ret[delicious_mapping[k]] = v if delicious_mapping[k]
        end

        ret
      end

  end
end
