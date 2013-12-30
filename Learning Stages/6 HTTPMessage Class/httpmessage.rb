require 'socket'
require 'logger'

logger = Logger.new('server.log')
logger.level = Logger::DEBUG

class HTTPMessage
  attr_accessor :msg
  def initialize 
    @msg = {}
  end

  def clientrequest(sock, site_root)
    ln = 0
    while line = sock.gets
      #logger.debug(line)
      break if line == "\r\n"
      if ln == 0
        @msg["Method"] = line.split(" ")[0]
        #Site root
        if line.split(" ")[1] == "/" then
          @msg["File"] = site_root
        elsif line.split(" ")[1][0] == "/" then
          @msg["File"] = line.split(" ")[1].gsub(/^./,"")
        else
          #Put Error as malformatted request
          @msg["File"] = line.split(" ")[1]
        end
        @msg["Protocol"] = line.split(" ")[2]
        ln += 1
      else
        @msg[line.match(/^[^:]*/).to_s] = line.match(/ .*/).to_s.gsub(/^./,"").chomp
      end
    end
    puts @msg
  end

  def get(sock)
    #puts "\nGet\n"
    sock.puts("HTTP/1.1 200 OK\n")
    sock.puts("Date: #{Time.now.utc.strftime("%a, %d %b %Y %T %Z")}\n")
    sock.puts("Server: Rubyisfun/0.1 (Unix)\n")
    #Lookup File last modified if available.  I'm assuming we don't display Last-Modified if not applicable.
    sock.puts("Last-Modified: Mon, 23 May 2005 22:38:34 GMT\n")
    #sock.puts("ETag: '3f80f-1b6-3e1cb03b'")
    sock.puts("Content-Type: text/html; charset=UTF-8\n")
    sock.puts("Content-Length: #{File.read(@msg["File"]).length}\n")
    #If a client includes the "Connection: close" header in the request, then the connection will be closed after the corresponding response
    sock.puts("Connection: close\n")
    sock.puts("\n")
    sock.puts(File.read(@msg["File"]))
    sock.puts("\r\n")
  end

end