require "./commands/help"
require "./commands/configure"

command = ARGV.size >= 1 ? ARGV[0] : "help"

case command
when "help"
  Ourcraft::Commands.help
when "configure"
  Ourcraft::Commands.configure
else
  print "Unknown command '#{command}'\n"
end
