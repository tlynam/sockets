require 'net/http'

print Net::HTTP.get('localhost', '/index.html')