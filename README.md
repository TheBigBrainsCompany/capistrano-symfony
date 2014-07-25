# Capistrano::Symfony

[![Gem Version](https://badge.fury.io/rb/capistrano-symfony.png)](http://badge.fury.io/rb/capistrano-symfony)

This gem will let you run Symfony tasks with Capistrano 3.x.

More informations about [Symfony & Capistrano (fr)](http://thebigbrainscompany.com/blog/posts/dployer-une-application-symfony-avec-capistrano)

## Documentation

* [Installation](#installation)
* [Usage](#usage)
* [Available tasks](#available-tasks)
* [Executing symfony console commands on the server directly from the local CLI](#executing-symfony-console-commands-on-the-server-directly-from-the-local-cli)
* [Handling parameters.yml](#handling-parametersyml)
* [Contributing](#contributing)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-symfony', '~> 0.3'
```

And then execute:

    $ bundle

Or install it yourself via gem:

    $ gem install capistrano-symfony

## Usage

Add a "require" statement in your application `Capfile`:

```ruby
require 'capistrano/symfony'
```

Here is a list of available options with their default values:

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

### Executing symfony console commands on the server directly from the local CLI

This library also provides a `symfony:run` task which allows access to any
Symfony console command.

With log level set to debug, from the command line you can run:

```bash
$ cap production symfony:run['list --env=prod']
```

Or from within a rake task using capistrano's `invoke`:

```ruby
task :my_custom_composer_task do
  invoke 'symfony:run', :'assets:install'
end
```

### Handling parameters.yml

If necessary, the `capistrano-symfony` module can upload the `app/config/parameters.yml` for you.

The `:symfony_parameters_upload` option can take tree values :
- **:never** : Never upload the local parameters file even when the remote version is different
- **:always** : Always upload the local parameters file when the remote version is different
- **:ask** : Always ask you before uploading the local parameters file when the remote version is different (**default**)

The local parameters file must be defined in the `app/config/`, see default value of `:symfony_parameters_path` option.

The parameters file name depends on the defined capistrano stages `parameters_#{fetch(:stage)}.yml`

By using this strategy, you can have different parameters files for each of your capistrano stages, e.g:
- app/config/parameters_staging.yml
- app/config/parameters_production.yml

The only **required configuration** is the `:linked_files`,

```ruby
set :linked_files, %w{app/config/parameters.yml}
```

**Note**: On first deployment, the parameters file will be uploaded in the shared folder. On next deployments, this will depend on the strategy you defined with the `:symfony_parameters_upload` option.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![The Big Brains Company - Logo](http://tbbc-valid.thebigbrainscompany.com/assets/images/logo-tbbc.png)](http://thebigbrainscompany.com)
