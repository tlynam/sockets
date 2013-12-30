require 'socket'

sock = TCPSocket.new 'localhost', 80

sock.puts "GET /index.html HTTP/1.1"
sock.puts "Host: localhost"
sock.puts " "

while line = sock.gets
	print line
end

sock.close