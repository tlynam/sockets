require 'socket'
require 'benchmark/ips'

Benchmark.ips do |x|
  # Typical mode, runs the block as many times as it can
  x.report("Multi Thread") { 
	s = TCPSocket.new 'localhost', 2000
	#line_num = 0
	while line = s.gets # Read lines from socket
	  #line_num += 1
	  #print "Line #{line_num}: " + line + "\n"        # and print them
	end
	#print "Closing connection :)\n"
	s.close             # close socket when done
  }
end

Benchmark.ips do |x|
  # Typical mode, runs the block as many times as it can
  x.report("Single Thread") { 
	s = TCPSocket.new 'localhost', 2001
	line_num = 0
	while line = s.gets # Read lines from socket
	  #line_num += 1
	  #print "Line #{line_num}: " + line + "\n"        # and print them
	end
	#print "Closing connection :)\n"
	s.close             # close socket when done
  }
end