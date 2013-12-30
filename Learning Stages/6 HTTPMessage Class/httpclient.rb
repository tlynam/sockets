require 'net/http'

print Net::HTTP.get('localhost', '/index.html', 2000)

=begin
uri = URI('http://www.google.com/')

Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request # Net::HTTPResponse object

  print response
end
=end