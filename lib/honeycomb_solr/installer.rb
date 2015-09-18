require "fileutils"

module HoneycombSolr
  class Installer
    class <<self
      def execute(options = {})
        new(options).execute
      end
    end

    def initialize(options)
      @verbose = !!options[:verbose]
      @force   = !!options[:force]
    end

    def execute
      return if base_solr_path == solr_home

      FileUtils.mkdir_p(solr_home)
      files_to_copy = Dir.glob([
        File.join(base_solr_path, "configsets/**/*.*"),
        File.join(base_solr_path, "*/core.properties"),
        File.join(base_solr_path, "solr.xml"),
      ])
      files_to_copy.each do |file|
        file = File.expand_path(file)
        relative_path = file.gsub(base_solr_path, "")
        dest = File.join(solr_home, relative_path)
        FileUtils.mkdir_p(File.dirname(dest))

        if File.exist?(dest)
          if force?
            say("Removing existing file #{dest}")
          else
            say("Skipping #{dest}")
            next
          end
        end

        say("Copying #{file} => #{dest}")
        FileUtils.cp(file, dest)
      end
    end

    private

    def solr_home
      HoneycombSolr.solr_home
    end

    def jetty_home
      HoneycombSolr.jetty_home
    end

    def base_solr_path
      @base_solr_path ||= File.join(jetty_home, "solr")
    end

    def verbose?
      @verbose
    end

    def force?
      @force
    end

    def say(message)
      if verbose?
        STDOUT.puts(message)
      end
    end
  end
end
