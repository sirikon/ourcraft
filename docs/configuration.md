# Configuration

- `JVM_MEMORY`: Amount of pre-assigned memory assigned to the Java Virtual
  Machine. Must be in a valid format for `java`'s `-Xmx` and `-Xms` arguments.
  - For example:
    - `512k` -> 512 kilobytes
    - `1024m` -> 1024 megabytes
    - `4g` -> 4 gigabytes
- `SERVER_JAR`: Defines the `.jar` file that should be ran when running
  the Minecrat server. Remember to include the `.jar` extension.
  - For example: `minecraft-server.jar`, `forge-1.12.2.jar`, `paper-200.jar`,
    etc.
