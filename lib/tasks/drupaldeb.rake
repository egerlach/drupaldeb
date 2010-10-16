namespace :drupaldeb do
  desc "Check all releases for updates and create new releases if updates available"
  task :update => :environment do
    Release.update
  end

  desc "Build all pending releases"
  task :build => :environment do
    Release.find_all_by_status("Pending").each do |r|
      r.build
    end
  end
end
