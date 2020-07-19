require "../minecraft/process_spawner"

module Ourcraft::Daemons::MinecraftRunner
  extend self

  private class MinecraftRunner
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

  class MinecraftRunnerOperator
    def initialize(@runner : MinecraftRunner)
      @stateChan = Channel(Bool).new
    end

    def start
      @stateChan.send(true)
    end

    def stop
      @stateChan.send(false)
    end

    def run
      loop do
        desiredState = @stateChan.receive
        if desiredState == true
          @runner.start
        else
          @runner.stop
        end
      end
    end
  end

  def start
    minecraftRunner = MinecraftRunner.new
    operator = MinecraftRunnerOperator.new(minecraftRunner)

    spawn do
      operator.run
    end

    return operator
  end
end
