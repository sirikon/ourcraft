<p align="center">
  <img src="./assets/logo.svg" height=80>
</p>

## Installation

Clone the repository and run:
```
sudo ./install.sh
```

## Usage
```
Usage: ourcraft <command> arguments

configure)        Starts a configuration wizard.
java-list)        Lists the available Java versions.
java-use)         Installs, if not installed yet,
                  the specified Java version and 
                  enables it for use with the server.
start)            Starts the minecraft server
service-install)  Installs a Systemd service
service-remove)   Removes the Systemd service
service-start)    Starts the Systemd service
service-stop)     Stops the Systemd service
attach)           Attaches to running service
backup)           Creates a new backup of the 'server'
                  folder
restic)           Access to underlying restic tool for
                  managing the backups
help)             Shows this help page.
```
