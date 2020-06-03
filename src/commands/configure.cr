require "../config/config"

module Ourcraft::Commands
  extend self

  def configure
    print "JVM memory: "
    jvmMemory = gets || ""

    print "Jar: "
    jar = gets || ""

    config = Config::Config.new(jvmMemory, jar)
    print config.@jvm_memory

    # print "JAR: "
    # password = STDIN.noecho &.gets
    # print "\n[#{password}]\n"
  end

end
