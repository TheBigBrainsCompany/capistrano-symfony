# Capistrano::Symfony

[![Gem Version](https://badge.fury.io/rb/capistrano-symfony.png)](http://badge.fury.io/rb/capistrano-symfony)

This gem will let you run Symfony tasks with Capistrano 3.x.

More informations about [Symfony & Capistrano (fr)](http://wozbe.com/fr/blog/2013-12-31-realiser-deploiement-automatique-application-symfony-avec-capistrano)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-symfony', '~> 0.1.3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-symfony

## Usage

Require in `Capfile` to use the default task:

```ruby
require 'capistrano/symfony'
```

Configurable options, shown here with defaults:

```ruby
set :symfony_roles, :web
set :symfony_default_flags, '--quiet --no-interaction'
set :symfony_assets_flags, '--symlink'
set :symfony_assetic_flags, ''
set :symfony_cache_clear_flags, ''
set :symfony_cache_warmup_flags, ''
set :symfony_env, 'prod'
set :symfony_parameters_upload, :ask
set :symfony_parameters_path, 'app/config/'
set :symfony_parameters_name_scheme, 'parameters_#{fetch(:stage)}.yml'
```

### Available tasks

- symfony:assets:install
- symfony:assetic:dump
- symfony:cache:clear
- symfony:cache:warmup
- symfony:parameters:upload
- symfony:app:clean_environment

### Using assetic

If you are using `assetic`, add in your config file

```ruby
before 'deploy:publishing', 'symfony:assetic:dump'
```

### Accessing symfony commands directly

This library also provides a `symfony:run` task which allows access to any
composer command.

With log level set to debug, from the command line you can run

```bash
$ cap production symfony:run['list --env=prod']
```

Or from within a rake task using capistrano's `invoke`

```ruby
task :my_custom_composer_task do
  invoke 'symfony:run', :'assets:install'
end
```

### Handling `parameters.yml`

The parameter `:symfony_parameters_upload` can take tree values : 
- **:never** : Never update the local parameter file even if the remote one is different (default)
- **:always** : Always update the local parameter file when the remote one is different
- **:ask** : Ask you to update the local parameter file is the remote one is different

The local parameter file have to be defined in the `app/config/`, e.g: app/config/parameters_staging.yml

The parameter name depends of the defined capistrano stages : `parameters_#{fetch(:stage)}.yml`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
