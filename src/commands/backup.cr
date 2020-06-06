module Ourcraft::Commands
  extend self

  def backup
    if !repositoryExists?
      status = runRestic(["init"])
      if status.@exit_status > 0
        exit status.@exit_status
      end
    end

    status = runRestic(["backup", "."])
    exit status.@exit_status
  end

  def restic(args : Array(String))
    status = runRestic(args)
    exit status.@exit_status
  end

  private def repositoryExists?
    return Dir.exists?(repositoryPath)
  end

  private def runRestic(args : Array(String))
    return Process.run(
      command: "restic",
      env: {
        "RESTIC_REPOSITORY" => repositoryPath,
        "RESTIC_PASSWORD"   => "ourcraft",
      },
      args: args,
      chdir: serverPath,
      output: Process::ORIGINAL_STDOUT,
      error: Process::ORIGINAL_STDERR)
  end

  private def repositoryPath
    return Path.new([Dir.current, "backup"]).to_s
  end

  private def serverPath
    return Path.new([Dir.current, "server"]).to_s
  end
end
