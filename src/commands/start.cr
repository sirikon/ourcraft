module Ourcraft::Commands
  extend self

  def start
    config = Services::DataService.readConfig
    state = Services::DataService.readState

    args = [] of String

    args << "-Xmx#{config.jvm_memory}"
    args << "-Xms#{config.jvm_memory}"
    args << "-XX:+UnlockExperimentalVMOptions"
    args << "-XX:+AlwaysPreTouch"
    args << "-XX:+UseG1GC"
    args << "-XX:G1NewSizePercent=30"
    args << "-XX:G1MaxNewSizePercent=40"
    args << "-XX:G1HeapRegionSize=8M"
    args << "-XX:G1ReservePercent=20"
    args << "-XX:G1HeapWastePercent=5"
    args << "-XX:G1MixedGCCountTarget=4"
    args << "-XX:+ParallelRefProcEnabled"
    args << "-XX:MaxGCPauseMillis=200"
    args << "-XX:+UnlockExperimentalVMOptions"
    args << "-XX:+DisableExplicitGC"
    args << "-XX:InitiatingHeapOccupancyPercent=15"
    args << "-XX:G1MixedGCLiveThresholdPercent=90"
    args << "-XX:G1RSetUpdatingPauseTimePercent=5"
    args << "-XX:SurvivorRatio=32"
    args << "-XX:+PerfDisableSharedMem"
    args << "-XX:MaxTenuringThreshold=1"

    args << "-jar" << config.server_jar
    args << "-nogui"

    javaHome = [Dir.current, "java", state.current_java_version]
    javaBins = javaHome + ["bin"]

    Process.exec(
      command: "java",
      env: {
        "JAVA_HOME" => Path.new(javaHome).to_s,
        "PATH"      => "#{Path.new(javaBins).to_s}:#{ENV["PATH"]}",
      },
      args: args,
      chdir: "./server")
  end
end
