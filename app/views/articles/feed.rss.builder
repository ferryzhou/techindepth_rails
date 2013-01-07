xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Tech in Depth"
    xml.description "hope you can enjoy"
    xml.link articles_url

    for post in @news_items
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate post.pubdate.to_s(:rfc822)
        xml.link article_url(post)
        xml.guid article_url(post)
      end
    end
  end
end