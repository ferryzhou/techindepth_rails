atom_feed do |feed|
  feed.title @title
  feed.updated @updated

  @news_items.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url article_url(item)
      entry.title item.title
      entry.content item.content, :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.pubdate.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name(item.magzine.name)
      end
    end
  end
end