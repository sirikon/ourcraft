module Ourcraft::Commands
  extend self

  def backup
    checkResticDependency
    checkServerFolderExists

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
    checkResticDependency
    checkServerFolderExists

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

  private def checkResticDependency
    if Process.find_executable("restic") == nil
      puts "Restic is required for backup commands."
      puts "Check Restic installation instructions: https://restic.net/#installation"
      exit 1
    end
  end

  private def checkServerFolderExists
    if !Dir.exists?(serverPath)
      puts "'server' folder not found."
      puts "You need to create this folder before running any backup command."
      puts "Create it manually, or generate it running the 'configure' command."
      exit 1
    end
  end
end
