namespace :reprepro do
  desc "Clear all data from the reprepro repository"
  task :clean do 
    FileUtils.rm_rf(Dir['db/reprepro/[^.]*'])
    FileUtils.rm_rf(Dir['public/debian/[^.]*'])
  end
end


