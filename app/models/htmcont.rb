require 'rubygems'
require 'json'
require 'net/http'

def htmcont(link)
   base_url = "http://htmcont.heroku.com/conts/g?format=json&"
   url = "#{base_url}&link=#{link}"
   resp = Net::HTTP.get_response(URI.parse(url))
   data = resp.body

   # we convert the returned JSON data to native Ruby
   # data structure - a hash
   result = JSON.parse(data)

   # if the hash has 'Error' as a key, we raise an error
   if result.has_key? 'Error'
      raise "web service error"
   end
   
   if result['error_type'] != 0
       raise 'htmcont can not extract'
   end
   
   return result['content']
end

# p htmcont('http://it.sohu.com/20121230/n362041123.shtml')
