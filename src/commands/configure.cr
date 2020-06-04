require "../config/config"

module Ourcraft::Commands
  extend self

  class Configurator < Config::Config
    def initialize(config : Config::Config | Nil = nil)
      if config
        {% for ivar in @type.instance_vars %}
          @{{ ivar }} = config.@{{ ivar }}
        {% end %}
      end
    end

    def build
      config = Config::Config.new
      {% for ivar in @type.instance_vars %}
        config.{{ ivar }} = @{{ ivar }}
      {% end %}
      return config
    end

    def prompt
      {% for ivar in @type.instance_vars %}
        {% description = ivar.annotation(Config::Description)[0] || ivar.stringify %}
        print "#{{{ description }}} (#{@{{ ivar }}}): "
        {{ ivar }}_new = gets || ""
        @{{ ivar }} = {{ ivar }}_new != "" ? {{ ivar }}_new : @{{ ivar }}
      {% end %}
    end
  end

  # autoconfigure

  def configure
    # print "JVM memory: "
    # jvmMemory = gets || ""

    # print "Jar: "
    # jar = gets || ""

    #config = Config::Config.new
    #config.jvm_memory = "4g"

    configurator = Configurator.new
    configurator.prompt
    config = configurator.build

    pp config

    # print "JAR: "
    # password = STDIN.noecho &.gets
    # print "\n[#{password}]\n"
  end

end
