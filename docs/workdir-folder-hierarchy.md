# Workdir Folder Hierarchy

This document describes the folder structure that Ourcraft expects in its
working directory during runtime.

```
workdir/
├─ config.json
├─ state.json
├─ server/
├─ java/
│   └─ <java-version>
└─ backup/
```

- `config.json`: This file stores all the non-sensitive Ourcraft
configuration. Information that could be added to VCS systems, or inside
non-encrypted backups.
- `state.json`: This file stores information relative to Ourcraft's current
state. It's fully managed by ourcraft and isn't supposed to be edited manually
unless you know what you're doing.
- `server/`: Here is where the Minecraft server is actually placed. It's the
working directory for the Minecraft Server process.
- `java/`: The folder where Java versions are installed by the built-in Java
version manager.
- `backup/`: This folder stores the [Restic](https://restic.net/) repository
used by Ourcraft for performing incremental backups.
