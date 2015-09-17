require "yaml"
require "honeycomb_solr/installer"
require "honeycomb_solr/server"
require "honeycomb_solr/version"

Dir[File.expand_path(File.join(File.dirname(__FILE__),"tasks/*.rake"))].each { |ext| load ext } if defined?(Rake)

module HoneycombSolr
  def self.root
    @root ||= File.expand_path("..", File.dirname(__FILE__))
  end

  def self.app_root
    if @app_root.nil?
      if defined?(::Rails) && defined?(::Rails.root)
        @app_root = ::Rails.root
      elsif defined?(APP_ROOT)
        @app_root = APP_ROOT
      else
        @app_root = "."
      end
    end
    @app_root
  end

  def self.logger
    if @logger.nil?
      if defined?(::Rails) && ::Rails.logger
        @logger = ::Rails.logger
      else
        @logger = ::Logger.new(STDOUT)
      end
    end
    @logger
  end

  def self.config
    @config ||= YAML.load_file(config_file).fetch(env)
  end

  def self.config_file
    if @config_file.nil?
      file = File.join(app_root, "config", "solr.yml")
      if !File.exists?(file)
        file = File.join(root, "config", "solr.yml")
      end
      @config_file = file
    end
    @config_file
  end

  def self.env
    if @env.nil?
      if defined?(::Rails) && defined?(::Rails.env)
        @env = ::Rails.env
      else
        @env = ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "default"
      end
    end
    @env
  end
end
