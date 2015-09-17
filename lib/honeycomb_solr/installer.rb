require "fileutils"

module HoneycombSolr
  class Installer
    class <<self
      def execute(solr_home, options = {})
        new(solr_home, options).execute
      end
    end

    attr_reader :solr_home

    def initialize(solr_home, options)
      @solr_home = File.expand_path(solr_home)
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

    def base_solr_path
      @base_solr_path ||= File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "jetty", "solr"))
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
