# this is the main file
# this application requires activerecord model Magzine and Article
# see migrations and schema

require_relative 'retrieve_indepth_data.rb'
require_relative 'htmcont.rb'
require_relative 'wp_xmlrpc.rb'

class TechInDepthApp

  def run
    crawl_links
    crawl_contents
    push_to_wp
  end

  def crawl_links
    p "crawling links ............."
    magzines = ['163', 'sina', 'ifeng', 'yahoo']
    magzines.each do |mag|
      nitems = get_indepth_items(mag)
      p "get #{nitems.size} items from #{mag}"
      nitems.each { |nitem| add_link_to_db(nitem) }
    end
  end
  
  # if exist, ignore
  def add_link_to_db(item)
    mag = Magzine.where(:name => item['source']).first
    if mag.nil?
      mag = Magzine.create(:name => item['source'])
    end
    if mag.articles.where(:title => item['title']).empty?
      p "adding article #{item['title']} ........"
      mag.articles.create(
        :title => item['title'], 
        :link => item['link'],
        :pubdate => item['pubdate']
        )
    end
  end
  
  
  def crawl_contents
    p "crawling full content ..........."
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
  
  def push_to_wp
    p "pushing stuff to wordpress ........"
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
