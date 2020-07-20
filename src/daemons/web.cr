require "http/server"
require "router"

require "./minecraft_runner"

module Ourcraft::Daemons::Web
  extend self

  class WebServer
    include Router

    def initialize(
      @minecraft_runner : MinecraftRunner::MinecraftRunner
    ); end

    def draw_routes
      post "/api/minecraft_process/start" do |context, params|
        @minecraft_runner.start
        context
      end
      post "/api/minecraft_process/stop" do |context, params|
        @minecraft_runner.stop
        context
      end
      get "/api/minecraft_process/status" do |context, params|
        status = @minecraft_runner.get_status
        reply_json(context, status.to_json)
      end
    end

    def run
      server = HTTP::Server.new(route_handler)
      address = server.bind_tcp 8080
      puts "Listening on http://#{address}"
      server.listen
    end

    private def reply_json(context, json)
      context.response.content_type = "application/json"
      context.response.print(json)
      context
    end

  end

  class MinecraftRunner::MinecraftRunnerStatus
    include JSON::Serializable
  end

  def run(runner : MinecraftRunner::MinecraftRunner)
    web_server = WebServer.new(runner)
    web_server.draw_routes
    web_server.run
  end
end
