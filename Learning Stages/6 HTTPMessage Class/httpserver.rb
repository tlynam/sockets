require './httpmessage'

site_root = "index.html"
listen_port = 2000

Socket.tcp_server_loop(listen_port) {|sock, client_addrinfo|
  Thread.new {
    begin
      message = HTTPMessage.new
      message.clientrequest(sock, site_root)
      case message.msg["Method"]
      when "GET"
        message.get(sock)
      end
    ensure
      @sock.close
    end
  }
}