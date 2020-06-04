require "../models/config"
require "../services/config_service"

module Ourcraft::Commands
  extend self

  def configure
    config = Services::ConfigService.readConfig
    {% for ivar in Models::Config.instance.instance_vars %}
      {% description = ivar.annotation(Models::Description)[0] || ivar.stringify %}
      print "#{{{ description }}} (#{config.{{ ivar }}}): "
      {{ ivar }}_new = gets || ""
      config.{{ ivar }} = {{ ivar }}_new != "" ? {{ ivar }}_new : config.{{ ivar }}
    {% end %}
    Services::ConfigService.writeConfig config
  end

end
