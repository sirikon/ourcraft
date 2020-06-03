module Ourcraft::Config

  class Config
    def initialize(
      @jvm_memory : String,
      @server_jar : String)
    end
  end

end
