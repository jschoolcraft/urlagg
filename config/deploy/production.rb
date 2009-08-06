set :host, "urlagg.com"
set :deploy_to, "/var/www/apps/#{application}"
set :branch, "master"

# only have god running in production
set :god_task, 'link_updater'
namespace :deploy do
  desc "Stop god"
  task :before_deploy do
    run "god stop #{god_task} && sleep 10"
  end
  
  desc "Restarting god"
  task :before_restart do
    run "god load #{current_path}/config/link_updater.god"
    run "god start #{god_task}"
  end
end
