# Workdir Folder Hierarchy

This document describes the folder structure that Ourcraft expects in its
working directory during runtime.

```
workdir/
├─ ourcraft.conf
├─ secrets.conf
├─ server/
├─ java/
│   └─ <java-version>
└─ backup/
```

- `ourcraft.conf`: This file stores all the non-sensitive Ourcraft
configuration. Information that could be added to VCS systems, or inside
non-encrypted backups.
- `secrets.conf`: This file stores sensitive information that should be taken
with extra care by the system administrator. Passwords could be placed here.
- `server/`: Here is where the Minecraft server is actually placed. It's the
working directory for the Minecraft Server process.
- `java/`: The folder where Java versions are installed by the built-in Java
version manager.
- `backup/`: This folder stores the [Restic](https://restic.net/) repository
used by Ourcraft for performing incremental backups.
