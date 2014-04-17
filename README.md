# Capistrano::Symfony

[![Gem Version](https://badge.fury.io/rb/capistrano-symfony.png)](http://badge.fury.io/rb/capistrano-symfony)

This gem will let you run Symfony tasks with Capistrano 3.x.

More informations about [Symfony & Capistrano (fr)](http://wozbe.com/fr/blog/2013-12-31-realiser-deploiement-automatique-application-symfony-avec-capistrano)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-symfony', '~> 0.2.0'
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
```

### Available tasks

- symfony:assets:install
- symfony:assetic:dump
- symfony:cache:clear
- symfony:cache:warmup
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
