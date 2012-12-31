require_relative 'htmcont.rb'

class Article < ActiveRecord::Base
  belongs_to :magzine
  
  def Article.crawl_contents
    Article.where(:content == '').each do |article|
      begin
        p "crawling #{article.link}"
        article.content = htmcont(article.link)
        article.save
        p 'success'
      rescue => e
        p e
      end
    end
  end
  
  def Article.push_to_wp
    
  end
  
end
