require "jettywrapper"

module HoneycombSolr
  class Server
    attr_reader :java_opts

    def initialize
      @java_opts = [
        "-Xmx256m",
        "-DsharedLib=#{File.join(jetty_home, 'solr', 'lib')}",
      ]
    end

    def start
      log_instance_output
      instance.start
    end

    def stop
      instance.stop
    end

    def restart
      stop
      # Give a little time for the service to shut down before starting it again
      sleep 1
      start
    end

    def running?
      pid ? true : false
    end

    def pid
      instance.pid
    end

    def status
      if running?
        "Running with PID #{pid}"
      else
        "Not running"
      end
    end

    private

    def port
      config.fetch("port")
    end

    def config
      HoneycombSolr.config
    end

    def solr_home
      HoneycombSolr.solr_home
    end

    def jetty_home
      HoneycombSolr.jetty_home
    end

    def logger
      HoneycombSolr.logger
    end

    def instance
      if @instance.nil?
        install_solr_home
        Jettywrapper.logger = logger
        Jettywrapper.configure(jetty_args)
        @instance = Jettywrapper.instance
      end
      @instance
    end

    def install_solr_home
      unless File.exists?(solr_home)
        HoneycombSolr::Installer.execute(verbose: true)
      end
    end

    def log_instance_output
      instance.process.io.stderr = instance_log_file
      instance.process.io.stdout = instance_log_file
      logger.warn "Logging jettywrapper stdout to #{instance_log_path}"
    end

    def instance_log_file
      if @instance_log_file.nil?
        FileUtils.mkdir_p(File.dirname(instance_log_path))
        @instance_log_file = File.open(instance_log_path, "w+")
      end
      @instance_log_file
    end

    def instance_log_path
      @instance_log_path ||= File.expand_path(File.join(HoneycombSolr.app_root, "log", "honeycomb_solr.log"))
    end

    def jetty_args
      {
        jetty_home: jetty_home,
        solr_home: solr_home,
        jetty_port: port,
        java_opts: java_opts,
        quiet: false,
      }
    end
  end
end
