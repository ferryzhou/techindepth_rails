desc "crawl data and push to wordpress"
task :crawl_n_push => :environment do |t, args|
  TechInDepthApp.new.run
end

