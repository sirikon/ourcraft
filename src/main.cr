require "./commands/help"
require "./commands/configure"
require "./commands/java"
require "./commands/start"
require "./commands/backup"

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
when "backup"
  Ourcraft::Commands.backup
when "restic"
  Ourcraft::Commands.restic ARGV.skip(1)
else
  print "Unknown command '#{command}'\n"
end
