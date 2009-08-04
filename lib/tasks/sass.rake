namespace :sass do
  desc 'Updates stylesheets if necessary from their Sass templates.'
  task :update => :environment do
    Sass::Plugin.update_stylesheets
  end
end