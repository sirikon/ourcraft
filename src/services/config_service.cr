require "json"

module Ourcraft::Services::ConfigService
  extend self

  class JSONConfig < Models::Config
    include JSON::Serializable
  end


  def readConfig
    content = File.read("config.json")
    return JSONConfig.from_json(content)
  end

  def writeConfig(config : JSONConfig)
    File.write("config.json", config.to_pretty_json)
  end

end
