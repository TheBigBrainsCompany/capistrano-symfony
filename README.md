# Capistrano::Symfony

[![Gem Version](https://badge.fury.io/rb/capistrano-symfony.png)](http://badge.fury.io/rb/capistrano-symfony)

This gem will let you run Symfony tasks with Capistrano 3.x.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-symfony'
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
set :symfony_assets_flags, '--symlink --quiet'
set :symfony_roles, :web
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
