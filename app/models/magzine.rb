require_relative 'retrieve_indepth_data.rb'

class Magzine < ActiveRecord::Base
  has_many :articles
  #=========== grab data
  def Magzine.crawl
    magzines = ['163', 'sina', 'ifeng', 'yahoo']
    magzines.each do |mag|
      nitems = get_indepth_items(mag)
      nitems.each { |nitem| add_item_to_db(nitem) }
    end
  end
  
  # if exist, ignore
  def Magzine.add_item_to_db(item)
    mag = Magzine.where(:name => item['source']).first
    if mag.nil?
      mag = Magzine.create(:name => item['source'])
    end
    if mag.articles.where(:title => item['title']).empty?
      mag.articles.create(
        :title => item['title'], 
        :link => item['link'],
        :pubdate => item['pubdate']
        )
    end
  end
  
end
