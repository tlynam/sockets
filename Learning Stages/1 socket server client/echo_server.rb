require 'socket'

Socket.tcp_server_loop(80) {|sock, client_addrinfo|
  Thread.new {
    begin
      print sock.gets
      sock.puts("Hello Client")
    ensure
      sock.close
    end
  }
}
