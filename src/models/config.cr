require "./annotations"

module Ourcraft::Models
  class Config
    @[Description("JVM Memory")]
    @[Validator(/^[0-9]+[kKmMgG]$/)]
    property jvm_memory : String = "1024m"

    @[Description("JMX Enabled")]
    @[Validator(/^(true|false)$/)]
    property jmx_enabled : String = "true"

    @[Description("JMX Port")]
    @[Validator(/^[0-9]+$/)]
    property jmx_port : String = "65000"

    @[Description("Server JAR")]
    property server_jar : String = "minecraft.jar"
  end
end
