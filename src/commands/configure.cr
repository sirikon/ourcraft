require "../config/config"

module Ourcraft::Commands
  extend self

  def configure
    config = Config::Config.new
    {% for ivar in Config::Config.instance.instance_vars %}
      {% description = ivar.annotation(Config::Description)[0] || ivar.stringify %}
      print "#{{{ description }}} (#{config.{{ ivar }}}): "
      {{ ivar }}_new = gets || ""
      config.{{ ivar }} = {{ ivar }}_new != "" ? {{ ivar }}_new : config.{{ ivar }}
    {% end %}
    pp config
  end

end
