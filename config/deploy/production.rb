set :host, "urlagg.com"
set :deploy_to, "/var/www/apps/#{application}"
set :branch, "master"

# Bluepill related tasks
# set user up in sudoers with: deploy ALL=(ALL) NOPASSWD: /opt/ruby-enterprise/bin/bluepill

after "deploy:update", "bluepill:quit", "bluepill:start"
namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    sudo "/opt/ruby-enterprise/bin/bluepill stop urlagg"
  end
 
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    sudo "/opt/ruby-enterprise/bin/bluepill load #{release_path}/config/production.pill"
  end
 
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    sudo "/opt/ruby-enterprise/bin/bluepill status"
  end
end
