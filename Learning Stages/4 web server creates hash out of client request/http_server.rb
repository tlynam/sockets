require 'socket'
require 'logger'

logger = Logger.new('logfile.log')
logger.level = Logger::DEBUG

Socket.tcp_server_loop(2000) {|sock, client_addrinfo|
  Thread.new {
    begin
      ln = 0
      msg = {}
      while line = sock.gets
        logger.debug(line)
        break if line == "\r\n"
        if ln == 0
          msg["Method"] = line.split(" ")[0]
          msg["File"] = line.split(" ")[1]
          msg["Protocol"] = line.split(" ")[2]
          ln += 1
        else
          msg[line.match(/^[^:]*/).to_s] = line.match(/ .*/).to_s.gsub(/^./,"").chomp
        end
      end
      print msg
      sock.puts("HTTP/1.1 200 OK")
      sock.puts("Date: Mon, 23 May 2005 22:38:34 GMT")
      sock.puts("Server: Apache/1.3.3.7 (Unix) (Red-Hat/Linux)")
  	  sock.puts("Last-Modified: Wed, 08 Jan 2003 23:11:55 GMT")
  	  #sock.puts("ETag: '3f80f-1b6-3e1cb03b'")
  	  sock.puts("Content-Type: text/html; charset=UTF-8")
  	  sock.puts("Content-Length: 146")
  	  sock.puts("Connection: close")
  	  sock.puts("\n")
      sock.puts(File.read('index.html'))
      sock.puts("\r\n")
    ensure
      sock.close
    end
  }
}
