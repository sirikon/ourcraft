require "http/server"

require "./minecraft_runner"

module Ourcraft::Daemons::Web
  extend self

  def run(operator : MinecraftRunner::MinecraftRunnerOperator)
    server = HTTP::Server.new do |context|
      if context.request.path == "/start"
        operator.start()
      elsif context.request.path == "/stop"
        operator.stop()
      end

      context.response.content_type = "text/plain"
      context.response.print context.request.path
    end

    address = server.bind_tcp 8080
    puts "Listening on http://#{address}"
    server.listen
  end
end
