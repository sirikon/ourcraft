require "crystar"
require "gzip"
require "http/client"

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

  def useJavaVersion(javaVersionID : String)
    javaVersion = getJavaVersionByID(javaVersionID)
    if !javaVersion
      print "Unknown version\n"
      return
    end

    if !Dir.exists?(Path.new(["java", javaVersionID]))
      print "Downloading...\n"
      download(javaVersion.url) do |io|
        Gzip::Reader.open(io) do |gzip|
          Crystar::Reader.open(gzip) do |tar|
            tar.each_entry do |entry|
              if entry.file_info.directory?
                next
              end

              parts = Path.new(entry.name).parts
              parts = parts.last(parts.size > 1 ? parts.size - 1 : 0)
              if parts.size == 0
                next
              end

              newPath = Path.new(["java", javaVersionID] + parts)
              if !Dir.exists?(newPath.dirname)
                Dir.mkdir_p(newPath.dirname)
              end
              File.write(newPath, entry.io, perm = entry.file_info.permissions)
            end
          end
        end
      end
    end

    state = Ourcraft::Services::DataService.readState
    state.current_java_version = javaVersionID
    Ourcraft::Services::DataService.writeState state
  end

  private def download(url : String, &block : IO -> Void)
    cb = uninitialized HTTP::Client::Response -> Void
    cb = ->(response : HTTP::Client::Response) do
      if response.status_code == 302
        HTTP::Client.get(response.headers["Location"], &cb)
      else
        block.call response.body_io
      end
    end
    HTTP::Client.get(url, &cb)
  end

  private def getJavaVersionByID(javaVersionID : String) : JavaVersion | Nil
    getJavaVersions.each
      .select { |v| v.id == javaVersionID }
      .to_a[0]?
  end
end
