namespace :drupaldeb do
  desc "Build all pending releases"
  task :build => :environment do
    Release.find_all_by_status("Pending").each do |r|
      r.build
    end
  end
end
