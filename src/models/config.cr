module Ourcraft::Models

  annotation Description; end
  annotation Validator; end

  class Config

    @[Description("JVM Memory")]
    @[Validator(/^[0-9]+[kKmMgG]$/)]
    property jvm_memory : String = "1024m"

    @[Description("Server JAR")]
    property server_jar : String = "minecraft.jar"

  end

end
