require_relative 'htmcont.rb'
require_relative 'wp_xmlrpc.rb'

class Article < ActiveRecord::Base
  belongs_to :magzine
  
  def Article.crawl_contents
    Article.where(:content => nil).each do |article|
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
    wp = WpXmlrpc.new
    Article.where(:wpid => nil).each do |article|
      p "pushing #{article.title}"
      d = article.pubdate
      magzine_name = article.magzine.name || ''
      wpid = wp.publish(
        'title' => article.title,
        'description' => article.content || '', 
        'mt_keywords' => [magzine_name],
        'categories' => [magzine_name],
        'dateCreated' => XMLRPC::DateTime.new(d.year, d.mon, d.mday, d.hour, d.min, d.sec)
      )
      article.wpid = wpid
      article.save
    end
  end
  
end
