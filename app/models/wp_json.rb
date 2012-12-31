# connect to wp via json api plugin

require 'net/http'
require 'open-uri'

class WpJson

  API_URI = 'http://localhost/wordpress/'
  API_USER = 'ferryzhou'
  API_PASSWORD = 'hello'
  
  def initialize
    nonce_response = JSON.parse(open(API_URI + "?json=get_nonce&controller=posts&method=create_post").read)
     if nonce_response['status'] == 'ok'
       @nonce = nonce_response['nonce']
     else
       raise nonce_response['error'].to_s
     end
  end
  
  def publish(article)
    url = URI.parse(API_URI + "posts/create_post")
    args = { 
      'nonce' => @nonce, 'author' => API_USER, 'user_password' => API_PASSWORD, 
      'status' => 'publish', 'title' => article.title, 'content' => article.content, 
      'categories' => article.categories.join(','), 'tags' => article.tags.join(','), 'type' => 'post'
    }
    resp, data = Net::HTTP.post_form(url, args)
    response = JSON.parse(data)
    if response['status'] == 'ok'
      puts response.inspect
    else
      raise response['error'].to_s
    end    
  end

  def get_recent_posts(article)
    res = JSON.parse(open(API_URI + "get_nonce/?json=get_recent_posts").read)
  end

end

wp_json = WpJson.new
wp_json.publish

