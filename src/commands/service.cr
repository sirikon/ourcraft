require "ecr"

module Ourcraft::Commands
  extend self

  def serviceInstall
    serviceName = "ourcraft"
    serviceDefinition = buildService(Dir.current)
    servicesDirectory = [Path.home.to_s, ".config", "systemd", "user"]
    serviceFile = servicesDirectory + ["#{serviceName}.service"]

    Dir.mkdir_p(Path.new(servicesDirectory))
    File.write(Path.new(serviceFile), serviceDefinition)
    runCmd("systemctl", ["--user", "enable", serviceName])
  end

  def serviceRemove
    serviceName = "ourcraft"
    servicesDirectory = [Path.home.to_s, ".config", "systemd", "user"]
    serviceFile = servicesDirectory + ["#{serviceName}.service"]

    runCmd("systemctl", ["--user", "disable", serviceName])
    File.delete(Path.new(serviceFile))
  end

  def serviceStatus
    serviceName = "ourcraft"
    runCmd("systemctl", ["--user", "status", serviceName])
  end

  def serviceStart
    serviceName = "ourcraft"
    runCmd("systemctl", ["--user", "start", serviceName])
  end

  def serviceStop
    serviceName = "ourcraft"
    runCmd("systemctl", ["--user", "stop", serviceName])
  end

  def serviceAttach
    serviceName = "ourcraft"
    Process.exec(
      command: "screen",
      args: ["-r", serviceName])
  end

  private def buildService(workdir : String)
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
