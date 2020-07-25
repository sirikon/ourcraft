require "../minecraft/process_spawner"

module Ourcraft::Daemons::MinecraftRunner
  extend self

  class MinecraftRunner
    property proc : Process?
    property input : IO::FileDescriptor?
    property output : IO::FileDescriptor?
    property outputTotal : IO::Memory?
    property waiters : Array(Channel(Nil)) = [] of Channel(Nil)

    def start
      if @proc != nil
        return
      end
      inputReader, inputWriter = IO.pipe(read_blocking: true)
      outputReader, outputWriter = IO.pipe(write_blocking: true)
      @input = inputWriter
      @output = outputReader
      @outputTotal = IO::Memory.new
      @proc = Minecraft::ProcessSpawner.spawn(inputReader, outputWriter, outputWriter)
      handle_output
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

    def write(bytes)
      if @proc == nil
        return
      end
      @input.not_nil!.write(bytes)
    end

    private def handle_output
      spawn do
        @output.not_nil!.each_byte do |c|
          byte = Slice.new(1, c)
          @outputTotal.not_nil!.write(byte)
          print String.new(byte)
        end
      end
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
