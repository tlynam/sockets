require 'socket'
require 'logger'

logger = Logger.new('server.log')
logger.level = Logger::DEBUG

class HTTPMessage
  attr_accessor :msg
  def initialize 
    @msg = {}
  end

=begin
  
{"Method"=>"POST", 
"File"=>"index.html",
"Protocol"=>"HTTP/1.1", 
"Host"=>"localhost:2000", 
"Connection"=>"keep-alive", 
"Content-Length"=>"25", 
"Cache-Control"=>"max-age=0", 
"Accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", 
"Origin"=>"http://localhost:2000",
"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",
"Content-Type"=>"application/x-www-form-urlencoded",
"Referer"=>"undefined",
"Accept-Encoding"=>"gzip,deflate,sdch",
"Accept-Language"=>"en-US,en;q=0.8",
"\r\n"=>"",
"nick=Test&bday=2013-12-17"=>""}
  
=end

  def clientrequest(sock, site_root)
    ln = 0
    while line = sock.gets
      #logger.debug(line)
      break if line == "\r\n\r"
      if ln == 0
        @msg["Method"] = line.split(" ")[0]
        #Site root
        if line.split(" ")[1] == "/" then
          @msg["File"] = site_root
        elsif line.split(" ")[1][0] == "/" then
          @msg["File"] = line.split(" ")[1].gsub(/^./,"")
        else
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

  def head(sock)
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
    sock.puts("\r\n")
  end

  def post(sock)
    sock.puts("HTTP/1.1 200 OK\n")
    sock.puts("Content-Type: text/html; charset=UTF-8\n")
    sock.puts("Date: #{Time.now.utc.strftime("%a, %d %b %Y %T %Z")}\n")
    sock.puts("Server: Rubyisfun/0.1 (Unix)\n")
    sock.puts("Content-Length: " + "Success".length.to_s + "\n")
    sock.puts("Connection: close\n")
    sock.puts("\n")
    sock.puts("Success\n")
    sock.puts("\r\n")
  end

end