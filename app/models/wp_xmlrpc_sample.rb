require 'xmlrpc/client'

# build a post

post = {
  'title'       => 'Post Title',
  'description' => 'The content of the post',
  'mt_keywords' => ['a', 'list', 'of', 'tags'],
  'categories'  => ['a', 'list', 'of', 'categories']
}

# initialize the connection

connection = XMLRPC::Client.new('localhost', '/wordpress/xmlrpc.php')

# make the call to publish a new post

connection.call(
  'metaWeblog.newPost',
  1,
  'ferryzhou',
  'hello',
  post,
  true
)
