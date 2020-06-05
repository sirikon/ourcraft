require "json"
require "../models/config"
require "../models/state"

module Ourcraft::Services::DataService
  extend self

  class JSONConfig < Models::Config
    include JSON::Serializable
    def initialize; end
  end

  class JSONState < Models::State
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

  def readState : Models::State
    if File.exists?("state.json")
      content = File.read("state.json")
      return JSONState.from_json(content)
    else
      return JSONState.new
    end
  end

  def writeState(state : Models::State)
    File.write("state.json", state.to_pretty_json)
  end

end
