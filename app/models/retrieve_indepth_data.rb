#encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'date'
require 'json'

def get_indepth_items(name)
  eval("get_#{name}_items")
end

def get_163_items

page_url = 'http://tech.163.com/special/000925CD/Cover.html'
content = open(page_url).read # need read first, otherwise content will be truncated
doc = Nokogiri::HTML(content)

nitems = Array.new
doc.search('div.group.clearfix').each do |group|
  source = group.search('h5').first.content
  group.search('ul li').each do |item|
    nitem = Hash.new
    a = item.search('a').first
    nitem['link'] = a['href']
    nitem['title'] = a.content
    nitem['source'] = source
    nitem['pubdate'] = DateTime.parse(item.search('span').first.content)
    nitems.push(nitem)
  end
end

nitems

end

def get_sina_items

page_url = 'http://roll.tech.sina.com.cn/iframe_famous/index.shtml'

doc = Nokogiri::HTML(open(page_url))

nitems = doc.search('ul li').collect do |item|
  nitem = Hash.new
  a = item.search('a').first
  nitem['link'] = a['href']
  nitem['title'] = a.content
  span_segs = item.search('span').first.content.split(' ')
  nitem['source'] = span_segs.first.gsub(/[(《》杂志]/, '')
  asegs = a['href'].split('/')
  nitem['pubdate'] = DateTime.parse(asegs[-2] + 'T' + span_segs.last)
  nitem
end

nitems
end

def get_ifeng_items
page_url = 'http://tech.ifeng.com/magazine/'

doc = Nokogiri::HTML(open(page_url))

nitems = doc.search('div.blockL ul.newsList.f14 li').collect do |item|
  nitem = Hash.new
  a = item.search('a').first
  nitem['link'] = a['href']
  asegs = a.content.split(']')
  nitem['source'] = asegs.first.gsub(/\[/, '')
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
  nitem['source'] = ''
  nitem['pubdate'] = DateTime.strptime(item.search('span').first.content, '%Y%m%d')
  nitem
end
nitems
end

