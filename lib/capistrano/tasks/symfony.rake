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
    desc "Symfony assets deployment"
    task :install do
      invoke 'symfony:run', :'assets:install', fetch(:symfony_assets_flags)
    end
  end
end

namespace :load do
  task :defaults do
    set :symfony_roles, :web
    set :symfony_assets_flags, '--symlink --quiet'
  end
end
