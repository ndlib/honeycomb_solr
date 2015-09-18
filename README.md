# HoneycombSolr

Solr / Jetty files for Honeycomb development environment

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'honeycomb_solr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install honeycomb_solr

Install the configuration files to your application:
```sh
bundle exec rake honeycomb_solr:install
```

Add the following to your .gitignore file:
```
/solr/*/data
```

## Usage

Start the server:
```sh
bundle exec rake honeycomb_solr:start
```

Stop the server:
```sh
bundle exec rake honeycomb_solr:stop
```

Restart the server:
```sh
bundle exec rake honeycomb_solr:restart
```
