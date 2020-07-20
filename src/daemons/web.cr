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

      get "/" do |context, params|
        context.response.content_type = "text/html"
        reply_file(context, "../spa/public/index.html")
      end

      get "/app.js" do |context, params|
        context.response.content_type = "text/javascript"
        reply_file(context, "../spa/public/build/app.js")
      end

      get "/main.css" do |context, params|
        context.response.content_type = "text/css"
        reply_file(context, "../spa/public/build/main.css")
      end

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

    private def reply_file(context, file_path)
      context.response.print `cat #{file_path}`
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
