# Capistrano::Symfony

[![Gem Version](https://badge.fury.io/rb/capistrano-symfony.png)](http://badge.fury.io/rb/capistrano-symfony)

This gem will let you run Symfony tasks with Capistrano 3.x.

More informations about [Symfony & Capistrano (fr)](http://wozbe.com/fr/blog/2013-12-31-realiser-deploiement-automatique-application-symfony-avec-capistrano)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-symfony', '~> 0.3'
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

The `capistrano-symfony` module can upload the `app/config/parameters.yml` for you when necessary.

The variable `:symfony_parameters_upload` can take tree values : 
- **:never** : Never upload the local parameters file even if the remote one is different
- **:always** : Always upload the local parameters file when the remote one is different
- **:ask** : Ask you to upload the local parameters file is the remote one is different (**default**)

The local parameters file have to be defined in the `app/config/`, see default value of `:symfony_parameters_path`.

The parameters name depends of the defined capistrano stages `parameters_#{fetch(:stage)}.yml`

Using this strategy, you can have different parameters files for each of your capistrano stages, e.g:
- app/config/parameters_staging.yml
- app/config/parameters_production.yml

The only **required configuration** is the `:linked_files`,

```ruby
set :linked_files, %w{app/config/parameters.yml}
```

**Note**: On first deployment, the parameters file will be uploaded in the shared folder. On the next one, it will depend on your `:symfony_parameters_upload` strategy.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
