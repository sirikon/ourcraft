require "../services/java_service"

module Ourcraft::Commands
  extend self

  def javaList
    currentVersionId = Services::JavaService.getCurrentJavaVersionID
    Services::JavaService.getJavaVersions.each do |version|
      print "[#{currentVersionId == version.id ? "x" : " "}] #{version.id}\n"
    end
  end

end
