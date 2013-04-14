#encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'date'
require 'json'

def get_indepth_items(source)
  eval("get_#{source}_items")
end

def get_indepth_content(source, link)
  p "get indepth content from #{source}"
  eval("get_#{source}_content(link)")
  #get_163_content(link)
end

def get_163_items

page_url = 'http://tech.163.com/special/000925CD/Cover.html'
content = open(page_url).read # need read first, otherwise content will be truncated
doc = Nokogiri::HTML(content)

nitems = Array.new
doc.search('div.group.clearfix').each do |group|
  magzine = group.search('h5').first.content
  magzine = 'unknown' if magzine.length > 10
  group.search('ul li').each do |item|
    nitem = Hash.new
    a = item.search('a').first
    nitem['source'] = '163'
    nitem['link'] = a['href']
    nitem['title'] = a.content
    nitem['magzine'] = magzine
    nitem['pubdate'] = DateTime.parse(item.search('span').first.content)
    nitems.push(nitem)
  end
end

nitems

end

def get_163_content(link)
  
  p "retrieving content from 163 with #{link} ...."
  content = open(link).read
  doc = Nokogiri::HTML(content)
  
  p doc.encoding

  el = doc.search("[text()*='下一页']").first
  
  if not el.nil? #multi page
    begin
    link = "#{link[0...-5]}_all.html"
    content = open(link).read
    doc = Nokogiri::HTML(content)
    rescue
      puts "no _all link"
    end
  end
  
  content = doc.search('#endText').first
  content.search('iframe').each { |n| n.remove }
  #content.search('p').each { |p| p.name = 'div'}
  content.css('img.icon').each { |p| p.parent.remove }
  #content.css('a').each { |e| p e.text(); e.replace(e.text()) }
  content.css('a').each { |e| e.replace(Nokogiri::XML::Text.new(e.text, e.document)) }
  
  img = content.search('img').first
  img = img.attribute('src').text if img
  
  c = Hash.new
  c['content'] = content.to_html
  #c['author']  = content.css('img.icon').first.attribute('alt')
  #c['magzine'] = doc.search('.endContent').css('a').first.text
  c['img'] = img
    #discussion = doc.css('script').text
    #p discussion
    #discussion_count = discussion ? discussion.to_i : -1
    #discussion = doc.search('#endpageUrl1').to_html
    #p discussion
    #c['discussion_count'] = discussion_count
  c
end


# gb2312 -> gbk
def get_sina_items

  p 'get sina items .....'

  page_url = 'http://roll.tech.sina.com.cn/iframe_famous/index.shtml'

  content = open(page_url).read
  
  p content.encoding
  
  content = content.force_encoding('gbk')
  
  p content.encoding
  
  doc = Nokogiri::HTML(content, nil, 'gbk')
  
  #p doc.to_s
  #p doc.encoding
  p doc.errors
  
  items = doc.search('ul li')
  
  p "found #{items.size} items"
  
  nitems = []
  items.each do |item|
    p item.to_s
    nitem = Hash.new
    begin
      a = item.search('a').first
      #p a.to_s
      #p item.search('span').first.to_s
      nitem['source'] = 'sina'
      nitem['link'] = a['href']
      nitem['title'] = a.content
      span_segs = item.search('span').first.content.split(' ')
      nitem['magzine'] = span_segs.first.gsub(/[(《》杂志]/, '')
      asegs = a['href'].split('/')
      nitem['pubdate'] = DateTime.parse(asegs[-2] + 'T' + span_segs.last)
      nitems.push(nitem)
      p nitem.to_s
    rescue => e
      puts e.backtrace.join("\n")
    end
  end
  
  p "extract #{nitems.size} items"

  nitems
end

def get_sina_content(link)
  
  p "retrieving content from sina with #{link} ...."
  content = open(link).read
  doc = Nokogiri::HTML(content, nil, 'gbk')
  
  p doc.encoding

  artibody = doc.search('#artibody').first
  img = artibody.search('img').first
  img = img.attribute('src').text if img
  
  c = Hash.new
  c['content'] = artibody.to_html.encode('utf-8')
  #c['content'] = "abc"
  c['img'] = img
  
  p c['content'].encoding
  c
end
                                          
def get_ifeng_items

  page_url = 'http://tech.ifeng.com/magazine/'

  doc = Nokogiri::HTML(open(page_url))

  nitems = doc.search('div.blockL ul.newsList.f14 li').collect do |item|
    nitem = Hash.new
    a = item.search('a').first
    nitem['link'] = a['href']
    asegs = a.content.split(']')
    nitem['magzine'] = asegs.first.gsub(/\[/, '')
    nitem['title'] = asegs.last.strip
    nitem['pubdate'] = DateTime.parse(item.search('span').first.content)
    nitem
  end
  nitems
end

def get_yahoo_items
  page_url = 'http://tech.cn.yahoo.com/shendu/'

  doc = Nokogiri::HTML(open(page_url))

  nitems = doc.search('ul.list_body li').collect do |item|
    nitem = Hash.new
    a = item.search('a').first
    nitem['link'] = a['href']
    nitem['title'] = a.content
    nitem['magzine'] = ''
    nitem['pubdate'] = DateTime.strptime(item.search('span').first.content, '%Y%m%d')
    nitem
  end
  nitems
end

