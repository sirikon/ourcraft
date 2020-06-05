require "./commands/help"
require "./commands/configure"
require "./commands/java"

command = ARGV.size >= 1 ? ARGV[0] : "help"

case command
when "help"
  Ourcraft::Commands.help
when "configure"
  Ourcraft::Commands.configure
when "java-list"
  Ourcraft::Commands.javaList
else
  print "Unknown command '#{command}'\n"
end
