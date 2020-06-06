require "ecr"

module Ourcraft::Commands
  extend self

  def serviceInstall
    serviceName = "ourcraft"
    service = buildService(`whoami`.strip, `whoami`.strip, Dir.current)

    tempDir = [Dir.current, "temp"]
    tempServiceFile = tempDir + ["systemd.service"]
    Dir.mkdir_p(Path.new(tempDir))
    File.write(Path.new(tempServiceFile), service)
    runCmd("sudo", ["mv", Path.new(tempServiceFile).to_s, "/etc/systemd/system/#{serviceName}.service"])
    runCmd("sudo", ["chown", "root:root", "/etc/systemd/system/#{serviceName}.service"])
    runCmd("sudo", ["systemctl", "enable", serviceName])
  end

  def serviceRemove
    serviceName = "ourcraft"
    runCmd("sudo", ["systemctl", "disable", serviceName])
    runCmd("sudo", ["rm", "/etc/systemd/system/#{serviceName}.service"])
  end

  def serviceStatus
    serviceName = "ourcraft"
    runCmd("sudo", ["systemctl", "status", serviceName])
  end

  def serviceStart
    serviceName = "ourcraft"
    runCmd("sudo", ["systemctl", "start", serviceName])
  end

  def serviceStop
    serviceName = "ourcraft"
    runCmd("sudo", ["systemctl", "stop", serviceName])
  end

  private def buildService(
    user : String,
    group : String,
    workdir : String)
    return ECR.render("#{__DIR__}/../assets/systemd.service")
  end

  private def runCmd(cmd : String, args : Array(String))
    status = Process.run(
      command: cmd,
      args: args,
      input: Process::ORIGINAL_STDIN,
      output: Process::ORIGINAL_STDOUT,
      error: Process::ORIGINAL_STDERR)
    if status.@exit_status > 0
      exit status.@exit_status
    end
  end

end
