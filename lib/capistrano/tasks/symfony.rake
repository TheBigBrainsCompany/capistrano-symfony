namespace :symfony do
  task :run, :command do |t, args|
    args.with_defaults(:command => :list)
    on roles fetch(:symfony_roles) do
      within release_path do
        execute :php, release_path.join('app/console'), args[:command], *args.extras, "--env=#{fetch(:symfony_env)}"
      end
    end
  end
  namespace :app do
    desc "Clean app environment"
    task :clean_environment do
      on roles(:web) do |host|
        within release_path do
          execute "find #{release_path.join('web/')} -maxdepth 1 -name 'app_*.php'  | grep -v '#{fetch(:symfony_env)}' | while read app_file; do rm $app_file; done;"
        end
      end
    end
  end
  namespace :assets do
    desc 'Symfony assets deployment'
    task :install do
      # invoke is not working
      # invoke 'symfony:run', :'assets:install', fetch(:symfony_assets_flags)
      on roles fetch(:symfony_roles) do
        within release_path do
          execute :php, release_path.join('app/console'), :'assets:install', fetch(:symfony_default_flags) + ' ' + fetch(:symfony_assets_flags), "--env=#{fetch(:symfony_env)}"
        end
      end
    end
  end
  namespace :assetic do
    desc 'Assetic dump'
    task :dump do
      on roles fetch(:symfony_roles) do
        within release_path do
          execute :php, release_path.join('app/console'), :'assetic:dump', fetch(:symfony_default_flags) + ' ' + fetch(:symfony_assetic_flags), "--env=#{fetch(:symfony_env)}"
        end
      end
    end
  end
  namespace :parameters do
      desc 'Upload parameters.yml'
      task :upload do
          on roles fetch(:symfony_roles) do
              within release_path do
                  if fetch(:symfony_parameters_name_scheme).nil?
                      set :symfony_parameters_name_scheme, "parameters_#{fetch(:stage)}.yml"
                  end

                  parameters_file_path = File.expand_path(
                      File.join(fetch(:symfony_parameters_path),
                                fetch(:symfony_parameters_name_scheme))
                  )


                  if File.file?(parameters_file_path)
                      upload = false
                      parameters_hash_local  = Digest::MD5.file(parameters_file_path).hexdigest
                      parameters_hash_remote = capture(:md5sum, release_path.join('app/config/parameters.yml')).split(' ')[0]
                      if parameters_hash_local.to_s == parameters_hash_remote.to_s
                          info 'Parameters are up-to-date'
                      else
                          info 'Parameters are not sync'
                          case fetch(:symfony_parameters_upload)
                              when :always
                                  upload = true
                              when :ask
                                  $stdout.write "Parameters seems to have changed, would you like to upload #{parameters_file_path} to the remote server? [y/N] "
                                  upload = 'y' == $stdin.gets.chomp.downcase ? true : false
                              else
                                  upload = false
                          end
                      end

                      if upload
                          if :linked_files.include?('app/config/parameters.yml') 
                              destination_file = shared_path.join('app/config/parameters.yml')
                          else
                              destination_file = release_path.join('app/config/parameters.yml')
                          end
                          upload! parameters_file_path, destination_file
                      end
                  else
                      info 'No parameters found, ignoring...'
                  end
              end
          end
      end
  end
  namespace :cache do
    desc 'Clears the cache'
    task :clear do
      # invoke is not working
      # invoke 'symfony:run', :'cache:clear', fetch(:symfony_cache_clear_flags)
      on roles fetch(:symfony_roles) do
        within release_path do
          execute :php, release_path.join('app/console'), :'cache:clear', fetch(:symfony_default_flags) + ' ' + fetch(:symfony_cache_clear_flags), "--env=#{fetch(:symfony_env)}"
        end
      end
    end
    desc 'Warms up an empty cache'
    task :warmup do
      # invoke is not working
      # invoke 'symfony:run', :'cache:warmup', fetch(:symfony_cache_warmup_flags)
      on roles fetch(:symfony_roles) do
        within release_path do
          execute :php, release_path.join('app/console'), :'cache:warmup', fetch(:symfony_default_flags) + ' ' + fetch(:symfony_cache_warmup_flags), "--env=#{fetch(:symfony_env)}"
        end
      end
    end
  end

  after 'deploy:updated', 'symfony:parameters:upload'
  before 'deploy:publishing', 'symfony:cache:warmup'
  before 'deploy:publishing', 'symfony:app:clean_environment'
  # this hook work using invoke
  # after 'deploy:updated', 'symfony:cache:warmup'
end

namespace :load do
  task :defaults do
    set :symfony_roles, :web
    set :symfony_default_flags, '--quiet --no-interaction'
    set :symfony_assets_flags, '--symlink'
    set :symfony_assetic_flags, ''
    set :symfony_cache_clear_flags, ''
    set :symfony_cache_warmup_flags, ''
    set :symfony_env,'prod'
    set :symfony_parameters_upload, :ask
    set :symfony_parameters_path, 'app/config/'
  end
end
