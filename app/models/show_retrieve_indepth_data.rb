require_relative 'retrieve_indepth_data.rb'

def show

#link = 'http://tech.163.com/12/0626/10/84TVBVKU00093879.html'
#link = 'http://tech.163.com/12/0214/11/7Q7JBVN70009387H.html' # multi pages
#link = 'http://tech.163.com/12/1010/10/8DERTQDI000940FL.html' # has image
#link = 'http://tech.163.com/13/0104/13/8KCJP4HC0009387B.html' #failed once

link = 'http://tech.163.com/13/0227/10/8ONAFBIS00093879.html'
a = get_163_content(link)
p a.to_json

#p get_163_items.to_json

#p "#{link[0...-5]}_all.html" # show multi-page link generation

end

show()