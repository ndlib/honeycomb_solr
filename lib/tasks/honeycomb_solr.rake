require "honeycomb_solr"

namespace :honeycomb_solr do
  desc "Copy the Honeycomb Solr configuration file"
  task :install do
    source = File.join(HoneycombSolr.root, "config", "solr.yml")
    dest = File.join(HoneycombSolr.app_root, "config", "solr.yml")
    if source != dest
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(source, dest)
    end
    HoneycombSolr::Installer.execute(verbose: true)
  end

  desc "Start the Honeycomb Solr server"
  task start: :environment do
    HoneycombSolr::Server.new.start
  end

  desc "Stop the Honeycomb Solr server"
  task stop: :environment do
    HoneycombSolr::Server.new.stop
  end

  desc "Restart the Honeycomb Solr server"
  task restart: :environment do
    HoneycombSolr::Server.new.restart
  end

  task :environment do
    # Run the main environment task if it exists so the Rails environment can be loaded
    Rake.application["environment"].invoke if Rake::Task.task_defined?("environment")
  end
end
