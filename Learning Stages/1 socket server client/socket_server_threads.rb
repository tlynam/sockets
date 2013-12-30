require 'socket'                # Get sockets from stdlib

server = TCPServer.new 80   # Socket to listen on port 2000

count = 0

loop do                        # Servers run forever
  Thread.start(server.accept) do |client|
  	print Thread.current 
  	count += 1
  	print count.to_s + "\n"
    client.puts(Time.now.ctime) # Send the time to the client
    client.puts "My first webserver!"
	client.puts "Closing the connection. Bye!"
    client.close                # Disconnect from the client
  end
end