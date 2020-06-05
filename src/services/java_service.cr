module Ourcraft::Services::JavaService
  extend self

  class JavaVersion
    include JSON::Serializable
    getter id : String
    getter url : String
  end

  def getJavaVersions : Array(JavaVersion)
    return Array(JavaVersion)
      .from_json {{ read_file("#{__DIR__}/../assets/java-versions.json") }}
  end

  def getCurrentJavaVersionID : String
    return Ourcraft::Services::DataService.readState.current_java_version
  end

end
