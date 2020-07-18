module Ourcraft::Daemons::MinecraftRunner
  extend self

  class MinecraftProcess
    property proc : Process?
    property waiters : Array(Channel(Nil)) = [] of Channel(Nil)

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
        input: STDIN,
        output: STDOUT,
        error: STDERR,
        chdir: ".")

      handle_process_termination
    end

    def stop
      if @proc == nil
        return
      end
      @proc.not_nil!.signal(Signal::INT)
      wait
    end

    private def handle_process_termination
      spawn do
        @proc.not_nil!.wait
        @waiters.each do |chan|
          chan.send(nil)
        end
        @waiters.clear
        @proc = nil
      end
    end

    private def wait
      chan = Channel(Nil).new
      @waiters << chan
      chan.receive
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
