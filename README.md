# Pironman 5 - Arch Linux Fork

Arch Linux compatible fork of the [SunFounder Pironman 5](https://github.com/sunfounder/pironman5) case software for Raspberry Pi 5.

## Table of Contents

- [About](#about)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Uninstall](#uninstall)
- [Compatible Systems](#compatible-systems)
- [Troubleshooting](#troubleshooting)
- [Debug](#debug)
- [Links](#links)

## About

This fork replaces all Debian/Ubuntu-specific tooling (`apt`, `dpkg`) with Arch Linux equivalents (`pacman`). It targets Arch Linux ARM and derivatives running on Raspberry Pi 5.

## Requirements

- Arch Linux ARM (aarch64) or any Arch-based distro on Raspberry Pi 5
- `git` and `python` installed
- Root / sudo access

## Installation

Install prerequisites if not already present:

```bash
sudo pacman -S --needed git python
```

Clone and run the installer:

```bash
cd ~
git clone https://github.com/ente0/pironman5-endeavour.git
cd ~/pironman5-endeavour
sudo python3 install.py
```

To skip the dashboard (InfluxDB):

```bash
sudo python3 install.py --disable-dashboard
```

To skip reboot prompt:

```bash
sudo python3 install.py --skip-reboot
```

## Usage

```bash
# Show help and current config
sudo pironman5 -c

# Start manually
sudo pironman5 start

# Service control
sudo systemctl start pironman5.service
sudo systemctl stop pironman5.service
sudo systemctl restart pironman5.service
sudo systemctl status pironman5.service
```

## Uninstall

```bash
sudo python3 install.py --uninstall
```

## Compatible Systems

Systems tested or targeted on Raspberry Pi 5:

| Operating System | Status |
| :--- | :---: |
| Arch Linux ARM (aarch64) | Target |
| EndeavourOS ARM | Target |
| Manjaro ARM | Target |

## Troubleshooting

### `ImportError: liblgpio.so.1: cannot open shared object file`

On Arch Linux, `liblgpio.so.1` is installed to `/usr/local/lib` which is not in the default ldconfig search path.

**Step 1** — find where the library was installed:

```bash
find / -name 'liblgpio.so*' 2>/dev/null
```

**Step 2** — if found under `/usr/local/lib`, register it and reload:

```bash
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/lgpio.conf
sudo ldconfig
sudo systemctl restart pironman5.service
```

**Step 3** — if the library is missing entirely, compile it from source:

```bash
cd ~/pironman5-endeavour
sudo bash scripts/install_lgpio.sh
sudo systemctl restart pironman5.service
```

**Step 4** — verify the library is visible to the linker:

```bash
ldconfig -p | grep liblgpio
```

The service file sets `LD_LIBRARY_PATH=/usr/local/lib` as an additional fallback.

## Debug

Clone the dependencies you want to debug or edit:

```bash
git clone https://github.com/sunfounder/pm_dashboard.git
git clone https://github.com/sunfounder/pm_auto.git
git clone https://github.com/sunfounder/sf_rpi_status.git
```

Reinstall a package from local source:

```bash
cd ~/pironman5-endeavour && sudo /opt/pironman5/venv/bin/pip3 uninstall pironman5 -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/pm_dashboard && sudo /opt/pironman5/venv/bin/pip3 uninstall pm_dashboard -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/pm_auto && sudo /opt/pironman5/venv/bin/pip3 uninstall pm_auto -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/sf_rpi_status && sudo /opt/pironman5/venv/bin/pip3 uninstall sf_rpi_status -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
```

Open a Python shell inside the venv:

```bash
sudo /opt/pironman5/venv/bin/python3
```

## Links

- Original project: <https://github.com/sunfounder/pironman5>
- SunFounder documentation: <https://docs.sunfounder.com/en/latest/>
- SunFounder store: <https://www.sunfounder.com/>
