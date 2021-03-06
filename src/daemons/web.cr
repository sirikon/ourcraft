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

    macro reply_spa_file(ctx, path, content_type)
      {{ctx}}.response.content_type = {{content_type}}
      {% if flag?(:embed_spa) %}
        {{ctx}}.response.print {{ read_file("#{__DIR__}/../../spa/public/" + path) }}
      {% else %}
        {{ctx}}.response.print File.read("#{__DIR__}/../../spa/public/" + {{path}})
      {% end %}
      {{ctx}}
    end

    def draw_routes
      get "/" do |context, params|
        reply_spa_file context, "index.html", "text/html"
      end

      get "/app.js" do |context, params|
        reply_spa_file context, "build/app.js", "text/javascript"
      end

      get "/main.css" do |context, params|
        reply_spa_file context, "build/main.css", "text/css"
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
      post "/api/minecraft_process/send_command" do |context, params|
        body = JSON.parse(context.request.body.not_nil!)
        command = body["command"].as_s + "\n"
        @minecraft_runner.write(command.encode("utf-8"))
        context
      end
    end

    def build_ws_handler
      return HTTP::WebSocketHandler.new do |socket|
        socket.on_message do |message|; end
        cancel = @minecraft_runner.output_observable.subscribe do |line|
          socket.send(line)
        end
        socket.on_close do
          cancel.call()
        end
      end
    end

    def run
      server = HTTP::Server.new([build_ws_handler, route_handler])
      address = server.bind_tcp("0.0.0.0", 8080)
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
