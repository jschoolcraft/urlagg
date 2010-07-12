class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag, :counter_cache => true
  
  scope :for_user, lambda { |u| {:conditions => { :user_id => u.id }} }
end
