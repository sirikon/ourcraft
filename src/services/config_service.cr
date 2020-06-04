require "json"

module Ourcraft::Services::ConfigService
  extend self

  class JSONConfig < Models::Config
    include JSON::Serializable
    def initialize; end
  end

  def readConfig : Models::Config
    if File.exists?("config.json")
      content = File.read("config.json")
      return JSONConfig.from_json(content)
    else
      return JSONConfig.new
    end
  end

  def writeConfig(config : Models::Config)
    File.write("config.json", config.to_pretty_json)
  end

end
