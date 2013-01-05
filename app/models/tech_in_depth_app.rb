# this is the main file
# this application requires activerecord model Magzine and Article
# see migrations and schema
# crawl several sites:
#   first extract links from list page
#      usually, we will get title, magzine name, url and date
#         however sometimes there are no magzine name or date
#      anyway, we assume url and title are unique to avoid duplication
#   secondly, extract each article content,
#      we will get content, magzine name, title, date, and
#      other data: author, img, discussion count, sharing count,
#

require_relative 'retrieve_indepth_data.rb'
require_relative 'htmcont.rb'
require_relative 'wp_xmlrpc.rb'

class TechInDepthApp

  def run
    crawl_links
    crawl_contents
    #push_to_wp
    'success'
  end

  def crawl_links
    p "crawling links ............."
    sources = ['163']
    sources.each do |source|
      nitems = get_indepth_items(source)
      p "get #{nitems.size} items from #{source}"
      nitems.each { |nitem| add_link_to_db(nitem) }
    end
  end
  
  # if exist, ignore
  def add_link_to_db(item)
    mag = Magzine.where(:name => item['magzine']).first
    if mag.nil?
      mag = Magzine.create(:name => item['magzine'])
    end
    if mag.articles.where(:title => item['title']).empty?
      p "adding article #{item['title']} ........"
      mag.articles.create(
        :title => item['title'], 
        :link => item['link'],
        :pubdate => item['pubdate'],
        :source => item['source'],
        :img => item['img']
        )
    end
  end
  
  
  def crawl_contents
    p "crawling full content ..........."
    Article.where(:content => nil).each do |article|
      begin
        p "crawling #{article.link}"
        c = get_indepth_content(article.source, article.link)
        article.content = c['content']
        article.author = c['author']
        if article.magzine.name == 'unknown'
          if c['magzine'] #
            mag = Magzine.where(:name => c['magzine']).first
            if mag.nil?
              mag = Magzine.create(:name => c['magzine'])
            end
            article.magzine = mag
          end
        end
        article.save
        p 'success'
      rescue => e
        p e.backtrace.join('\n')
      end
    end
  end
  
  def clear_all
    Magzine
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
