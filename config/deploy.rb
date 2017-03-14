# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'jihi'
set :repo_url, 'https://github.com/fero46/quickbid.git'
set :deploy_to, "/home/jihi/applications/jihi"

set :scm, :git


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :restart, :symlink_upload do
    on roles(:app), in: :sequence, wait: 5 do
      execute :rm, "-rf","#{release_path}/log" 
      execute :ln, "-s", "#{deploy_to}/shared/log #{release_path}/log"
      execute :rm, "-rf","#{release_path}/public/uploads" 
      execute :ln, "-s", "#{deploy_to}/shared/uploads #{release_path}/public/uploads"
      execute :rm, "-rf","#{release_path}/tmp" 
      execute :ln, "-s", "#{deploy_to}/shared/tmp #{release_path}/tmp"
      execute :ln, "-s", "#{deploy_to}/shared/certs #{release_path}/certs"

    end
  end

  before :compile_assets, :symlink_database do
    on roles(:app), in: :sequence, wait: 5 do
      execute :ln, "-nfs", "#{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    end
  end

end
 