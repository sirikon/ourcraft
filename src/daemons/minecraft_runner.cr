require "../minecraft/process_spawner"

module Ourcraft::Daemons::MinecraftRunner
  extend self

  class MinecraftRunner
    property proc : Process?
    property waiters : Array(Channel(Nil)) = [] of Channel(Nil)

    def start
      if @proc != nil
        return
      end
      @proc = Minecraft::ProcessSpawner.spawn
      handle_process_termination
    end

    def stop
      if @proc == nil
        return
      end
      @proc.not_nil!.signal(Signal::INT)
      wait
    end

    def get_status
      return MinecraftRunnerStatus.new(@proc != nil)
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

  class MinecraftRunnerStatus
    def initialize(@running : Bool); end
  end

  def start
    return MinecraftRunner.new
  end
end
