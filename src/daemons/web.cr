require "http/server"

module Ourcraft::Daemons::Web
  extend self

  def run(chan : Channel(Bool))
    server = HTTP::Server.new do |context|
      if context.request.path == "/start"
        chan.send(true)
      elsif context.request.path == "/stop"
        chan.send(false)
      end

      context.response.content_type = "text/plain"
      context.response.print context.request.path
    end

    address = server.bind_tcp 8080
    puts "Listening on http://#{address}"
    server.listen
  end
end
