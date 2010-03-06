set :host, "urlagg.com"
set :deploy_to, "/var/www/apps/#{application}"
set :branch, "master"

# only have god running in production
set :god_task, 'link_updater'
namespace :deploy do
  desc "Stop god"
  task :before_deploy do
    run "/opt/ruby-enterprise/bin/god stop #{god_task} && sleep 10"
  end
  
  desc "Restarting god"
  task :before_restart do
    run "/opt/ruby-enterprise/bin/god load #{current_path}/config/link_updater.god"
    run "/opt/ruby-enterprise/bin/god start #{god_task}"
  end
end

# Bluepill related tasks
# set user up in sudoers with: deploy ALL=(ALL) NOPASSWD: /opt/ruby-enterprise/bin/bluepill

after "deploy:update", "bluepill:quit", "bluepill:start"
namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    sudo "/opt/ruby-enterprise/bin/bluepill stop"
    sudo "/opt/ruby-enterprise/bin/bluepill quit"
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
