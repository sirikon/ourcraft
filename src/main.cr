require "./daemons/web"
require "./daemons/minecraft_runner"

module Ourcraft
  channel = Channel(Bool).new

  spawn do
    Daemons::Web.run(channel)
  end
  spawn do
    Daemons::MinecraftRunner.run(channel)
  end

  sleep
end
