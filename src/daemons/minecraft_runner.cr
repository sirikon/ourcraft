module Ourcraft::Daemons::MinecraftRunner
  extend self

  class MinecraftProcess
    property proc : Process?

    def start
      if @proc != nil
        return
      end
      @proc = Process.new(
        command: "ping",
        env: {
          "PATH" => ENV["PATH"],
        },
        args: ["8.8.8.8"],
        output: STDOUT,
        error: STDERR,
        chdir: ".")
    end

    def stop
      if @proc == nil
        return
      end
      @proc.not_nil!.signal(Signal::INT)
      @proc.not_nil!.wait
      @proc = nil
    end
  end

  def run(chan : Channel(Bool))
    minecraftProcess = MinecraftProcess.new

    loop do
      desiredStatus = chan.receive
      if desiredStatus == true
        minecraftProcess.start
      else
        minecraftProcess.stop
      end
    end
  end
end
