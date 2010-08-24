namespace :typus do

  desc "List current roles."
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "#{role.first.capitalize} role has access to:"
      role.last.each { |key, value| puts "- #{key}: #{value}" }
    end
  end

  desc "Install acts_as_list, acts_as_tree and paperclip."
  task :misc do
    plugins = [ "git://github.com/thoughtbot/paperclip.git",
                "git://github.com/rails/acts_as_list.git",
                "git://github.com/rails/acts_as_tree.git" ]
    system "rails plugin install #{plugins.join(" ")} --force"
  end

end
