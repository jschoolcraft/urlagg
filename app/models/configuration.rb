class Configuration < ActiveRecord::Base
  class <<self
    def dont_update_bookmarks_before
      config = Configuration.find_by_name('dont_update_bookmarks_before')
      config && Time.parse(config.value) || 1.minute.ago
    end
    
    def dont_update_bookmarks_before=(new_value)
      Configuration.find_or_create_by_name('dont_update_bookmarks_before').update_attributes(:value => new_value.to_s)
    end
  end
end
