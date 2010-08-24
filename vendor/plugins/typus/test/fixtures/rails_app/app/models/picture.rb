class Picture < ActiveRecord::Base
  # simulate Paperclip
  def self.attachment_definitions
    {:picture => true}
  end
end
