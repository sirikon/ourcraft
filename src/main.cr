require "./commands/help"
require "./commands/configure"
require "./commands/java"
require "./commands/start"
require "./commands/backup"
require "./commands/service"
require "./commands/version"
require "./daemons/web"
require "./daemons/minecraft_runner"

module Ourcraft

  command = ARGV.size >= 1 ? ARGV[0] : "help"

  case command
  when "help"
    Ourcraft::Commands.help
  when "configure"
    Ourcraft::Commands.configure
  when "java-list"
    Ourcraft::Commands.javaList
  when "java-use"
    Ourcraft::Commands.javaUse ARGV[1]
  when "start"
    Ourcraft::Commands.start
  when "service-install"
    Ourcraft::Commands.serviceInstall
  when "service-remove"
    Ourcraft::Commands.serviceRemove
  when "service-status"
    Ourcraft::Commands.serviceStatus
  when "service-start"
    Ourcraft::Commands.serviceStart
  when "service-stop"
    Ourcraft::Commands.serviceStop
  when "service-attach"
    Ourcraft::Commands.serviceAttach
  when "backup"
    Ourcraft::Commands.backup
  when "restic"
    Ourcraft::Commands.restic ARGV.skip(1)
  when "version"
    Ourcraft::Commands.version
  when "daemon"
    runner = Daemons::MinecraftRunner.start()
    spawn do
      Daemons::Web.run(runner)
    end
    sleep
  else
    print "Unknown command '#{command}'\n"
  end

end
