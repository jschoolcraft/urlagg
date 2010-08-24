Factory.define :picture do |f|
  f.title "Some picture"
  f.picture_file_name "dog.jpg"
  f.picture_content_type "image/jpeg"
  f.picture_file_size "175938"
  f.picture_updated_at 3.days.ago.to_s(:db)
end
