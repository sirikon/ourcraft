require "../config/config"

module Ourcraft::Commands

  # macro autoconfigure
  #   def configure
  #     config = Config::Config.new
  #     {% args = Config::Config.instance_vars %}
  #     print {{ args.stringify }} + "\n"
  #     {% for arg in args %}
  #       print {{ "#{arg.name}" }} + ": " + config.@{{ arg.name }} + "\n"
  #     {% end %}
  #   end
  # end

  class Configurator < Config::Config
    def initialize(config : Config::Config)
      {% for ivar in @type.instance_vars %}
        @{{ ivar }} = config.@{{ ivar }}
      {% end %}
    end

    def properties
      {% for ivar in @type.instance_vars %}
        print "#{{{ ivar.annotation(Config::Description)[0] }}}: "
        print "#{@{{ ivar }}}\n"
      {% end %}
    end
  end

  extend self
  # autoconfigure

  def configure
    # print "JVM memory: "
    # jvmMemory = gets || ""

    # print "Jar: "
    # jar = gets || ""

    config = Config::Config.new
    config.jvm_memory = "4g"

    configurator = Configurator.new(config)
    configurator.properties

    # print "JAR: "
    # password = STDIN.noecho &.gets
    # print "\n[#{password}]\n"
  end

end
