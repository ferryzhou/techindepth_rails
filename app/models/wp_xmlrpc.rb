require 'xmlrpc/client'

class WpXmlrpc

  API_USER = 'ferryzhou'
  API_PASSWORD = 'hello'
  
  def initialize
    @connection = XMLRPC::Client.new('localhost', '/wordpress/xmlrpc.php')
  end
  
  def publish(post)
    @connection.call('metaWeblog.newPost', 1, API_USER, API_PASSWORD, post, true)
  end

  def get_recent_posts()
    @connection.call('metaWeblog.getRecentPosts', 1, API_USER, API_PASSWORD, 20)
  end

end

def show_wpxmlrpc
  wp = WpXmlrpc.new
  p wp.publish({
    'title' => 'hello', 
    'description' => 'ruby', 
    'mt_keywords' => ['testkw'],
    'dateCreated' => XMLRPC::DateTime.new(2012, 12, 19, 4, 5, 6)
  })
  p wp.get_recent_posts
end

show_wpxmlrpc
