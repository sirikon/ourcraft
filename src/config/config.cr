module Ourcraft::Config

  annotation Description; end

  class Config

    @[Description("JVM Memory")]
    property jvm_memory : String = "1024m"

    @[Description("Server JAR")]
    property server_jar : String = "minecraft.jar"

  end

end
