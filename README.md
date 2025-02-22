# htoptty: run htop on a TTY

`htoptty` is a small script to run htop on a TTY, such as `/dev/tty7`. This can
be useful when you have a display connected to a device and want to securely run
htop on the display unsupervised, or want your VM manager to show htop output on
all of your VM screens without having to log in.

`htoptty` creates a no-login user to run htop and outputs directly to a TTY. The
htop instance does not accept any keyboard or mouse interaction of any kind and
has multiple layers of isolation separating the htop I/O from TTY I/O.

This repo provides a script to install `htoptty` and a systemd service.

### Installation

Prerequisites:
- A Linux system with systemd (built on Ubuntu Server 22.04)
- `htop` installed on the system
- `curl` for downloading the `htoptty` script

To install `htoptty`, follow these steps:

Easy (default config on TTY7):
```bash
curl "https://raw.githubusercontent.com/jdgregson/htoptty/refs/heads/master/setup.sh" | sudo bash
```

Custom:
1. Clone the repository to your local machine: `git clone https://github.com/jdgregson/htoptty.git`
1. Navigate to the directory containing the `setup.sh` script: `cd htoptty`
1. Make any needed config changes to `setup.sh`
1. Make the setup script executable: `chmod +x setup.sh`
1. Run the setup script with root privileges: `sudo ./setup.sh`

## Using `htoptty`

### Starting service
```bash
systemctl start htoptty
```

### Stopping service
```bash
systemctl stop htoptty
```

### Viewing htoptty output

You can view the htop output by changing your display to use the configured TTY
(typically TTY1 or TTY7).

On systems such as Ubuntu, you can use `Crtl + Alt + F<num>` locally to switch
TTYs, where `<num>` is a number between 1 and 7.

## Configuration

The `setup.sh` script uses the following default configuration:

```bash
HTOP_COMMAND="htop -d 50 --no-mouse --sort-key PERCENT_CPU"
USE_TTY=7
SCRIPT_PATH=/usr/local/bin/htoptty
USE_USER=htoptty
```
