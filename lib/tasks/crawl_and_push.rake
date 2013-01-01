desc "crawl data and push to wordpress"
task :crawl_n_push => :environment do |t, args|
  Article.crawl_contents
  Article.push_to_wp
end

