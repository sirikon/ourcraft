require "../models/config"
require "../services/data_service"

module Ourcraft::Commands
  extend self

  def configure
    config = Services::DataService.readConfig
    {% for ivar in Models::Config.instance.instance_vars %}
      {% descriptionAnn = ivar.annotation(Models::Description) %}
      {% description = descriptionAnn != nil ? descriptionAnn[0] : ivar.stringify %}
      {% validatorAnn = ivar.annotation(Models::Validator) %}
      {% validator = validatorAnn != nil ? validatorAnn[0] : nil %}

      {{ ivar }}_done = false
      while !{{ ivar }}_done

        print "#{{{ description }}} (#{config.{{ ivar }}}): "
        {{ ivar }}_new = gets || ""

        if {{ ivar }}_new == ""
          {{ ivar }}_done = true
        elsif {{ validator }} != nil && {{ validator }} =~ {{ ivar }}_new != 0
          print "Invalid value '#{{{ ivar }}_new}'\n"
          print "Expected: #{{{ validator.stringify }}}\n"
        else
          config.{{ ivar }} = {{ ivar }}_new != "" ? {{ ivar }}_new : config.{{ ivar }}
          {{ ivar }}_done = true
        end

      end

    {% end %}
    Services::DataService.writeConfig config
  end
end
