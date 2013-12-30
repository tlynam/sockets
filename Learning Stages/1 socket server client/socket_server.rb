require 'socket'

server = TCPServer.new 2001 # Server bound to port 2001

count = 0

loop do
  client = server.accept    # Wait for a client to connect
  print Thread.current 
  count += 1
  print count.to_s + "\n"
  client.puts "Hello !"
  client.puts "The time is #{Time.now}"
  client.close
end