require "../services/java_service"

module Ourcraft::Commands
  extend self

  def javaList
    currentVersionID = Services::JavaService.getCurrentJavaVersionID
    Services::JavaService.getJavaVersions.each do |version|
      print "[#{currentVersionID == version.id ? "x" : " "}] #{version.id}\n"
    end
  end

  def javaUse(javaVersionID : String)
    Services::JavaService.useJavaVersion javaVersionID
  end
end
