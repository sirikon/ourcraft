<p align="center">
  <img src="./assets/logo.svg" height=80>
</p>

<p align="center">
  CLI tool for hosting and managing a Minecraft server
</p>
<p align="center">
  ⚠️ <b>Alpha</b> software under development ⚠️
</p>

## Features

- **Agnostic to the Minecraft version**: Run any Minecraft version or any
variant of the server. Bukkit, Spigot, Paper, Forge... you name it.
- **Built-in Java version management**: Use the Java version that better works
with your setup.
- **Backups**: Provided by the fantastic [Restic](https://restic.net/).
- **Run as a service**: Ourcraft can configure the required Systemd service
definition for you.
- **Easy**: Just give it a try!

## Installation

Clone the repository and run the following:

```bash
make
sudo make install
```

If you prefer a pre-compiled binary, head to the
[releases section](https://github.com/sirikon/ourcraft/releases) and download
it from there.

Make sure that the `ourcraft` binary is present in your `PATH`.

## Usage

Create a new folder to host your server and `cd` into it. Then run the
`configure` subcommand to launch an interactive configuration wizard.

```bash
mkdir coolserver
cd coolserver
ourcraft configure
```

The wizard will ask you for each possible setting, showing between parentheses
the default value.

Once the wizard finishes, there's a new file inside `coolserver` called
`config.json` that stores the configuration, and a folder called `server`
that contains your actual Minecraft server, but it's empty for now.

Download inside the `server` folder a Minecraft server `.jar` file. You can use
any official or custom server. If you're not sure, let's use the
[official one](https://www.minecraft.net/en-us/download/server/).

Make sure that the downloaded `.jar` file name matches the "Server JAR"
configuration introduced previously. Remember that you can run
`ourcraft configure` whenever you want to change the configuration if needed.

Now we need a **java installation**, which is really easy:

```bash
ourcraft java-list
# Choose a version from the list, and then run:
ourcraft java-use <version> # For example: openjdk-8u252-hs
```
That will download and install the specified Java version locally. It will not
affect your global java installation, it will just work for the minecraft
server. You can see it's installed in a new folder called `java` inside
`coolserver`.

Once that's done, run the server with:

```bash
ourcraft start
```

You'll probably need to accept some EULA or something like that, but once
that's done, you'll have a Minecraft server running!

That will just work as long as your terminal emulator is open, but we can
install it as a service.

### Install as a service

This requires **systemd** and
[systemd/user](https://wiki.archlinux.org/index.php/Systemd/User) configured
in your current user. If you're using Ubuntu 20.04 (desktop or server) you have
everything set up already.

To install our Minecraft server as a service that runs in background, just run:

```bash
ourcraft service-install
```
And then, to start it:

```bash
ourcraft service-start
```
That's it! You're running Minecraft in the background. To get access to the
console, run this:

```bash
ourcraft service-attach
```

**But be careful**, this attaches to a
[GNU Screen](https://www.gnu.org/software/screen/) session. If you hit
`Ctrl+c` in your terminal emulator, the server **will stop**. To detach from
the server console without stopping the server, you need to hit `Ctrl+a` and
then just `d`. That, for Screen, means "Action -> Detach".
