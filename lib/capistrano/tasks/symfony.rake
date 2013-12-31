namespace :symfony do
  task :run, :command do |t, args|
    args.with_defaults(:command => :list)
    on roles fetch(:symfony_roles) do
      within release_path do
        execute :php, release_path.join('app/console'), args[:command], *args.extras
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
          execute :php, release_path.join('app/console'), :'assets:install', fetch(:symfony_default_flags) << ' ' << fetch(:symfony_assets_flags)
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
          execute :php, release_path.join('app/console'), :'cache:clear', fetch(:symfony_default_flags) << ' ' << fetch(:symfony_cache_clear_flags)
        end
      end
    end
    desc 'Warms up an empty cache'
    task :warmup do
      # invoke is not working
      # invoke 'symfony:run', :'cache:warmup', fetch(:symfony_cache_warmup_flags)
      on roles fetch(:symfony_roles) do
        within release_path do
          execute :php, release_path.join('app/console'), :'cache:warmup', fetch(:symfony_default_flags) << ' ' << fetch(:symfony_cache_warmup_flags)
        end
      end
    end
  end

  before 'deploy:published', 'symfony:cache:warmup'
  # this hook work using invoke
  # after 'deploy:updated', 'symfony:cache:warmup'
end

namespace :load do
  task :defaults do
    set :symfony_roles, :web
    set :symfony_default_flags, '--quiet --no-interaction --env=prod'
    set :symfony_assets_flags, '--symlink'
    set :symfony_cache_clear_flags, ''
    set :symfony_cache_warmup_flags, ''
  end
end
