require 'net/http'

#Get Request
print Net::HTTP.get('localhost', '/index.html', 2000)


#Head Request
response = nil
Net::HTTP.start('localhost', 2000) {|http|
  response = http.head('/index.html')
}
puts response['content-type']
