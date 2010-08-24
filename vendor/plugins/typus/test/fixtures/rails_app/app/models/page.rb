class Page < ActiveRecord::Base

  acts_as_tree

  STATUS = { "pending" => "Pending",
             "published" => "Published",
             "unpublished" => "Not Published" }

end
