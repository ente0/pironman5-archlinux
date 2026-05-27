# Pironman 5 - Arch Linux Fork (Endeavour)

Pironman 5 case - Arch Linux compatible fork

Quick Links:

- [Pironman 5](#pironman-5---arch-linux-fork-endeavour)
  - [About Pironman5](#about-pironman5)
  - [Links](#links)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Update](#update)
  - [Compatible Systems](#compatible-systems)
    - [Debug](#debug)
  - [About SunFounder](#about-sunfounder)
  - [Contact us](#contact-us)

## About Pironman5

## Links

- SunFounder Online Store &emsp; <https://www.sunfounder.com/>
- Documentation &emsp; <https://docs.sunfounder.com/en/latest/>

## Installation

For systems that don't have git and python3 pre-installed you need to install them first

```bash
sudo pacman -S --needed git python
```

Execute the installation script

```bash
cd ~
git clone https://github.com/ente0/pironman5-endeavour.git
cd ~/pironman5-endeavour
sudo python3 install.py
```

## Usage

-

## Update

<https://github.com/sunfounder/pironman5/blob/main/CHANGELOG.md>

## Compatible Systems

Operating systems targeting Arch Linux on Raspberry Pi 5:

Operate System|Release Date|Compatible
:---|:---:|:---:
Arch Linux ARM (aarch64)|–|Target
EndeavourOS ARM|–|Target

### Debug

Clone the dependency you want to debug or edit

```bash
git clone https://github.com/sunfounder/pironman5.git
git clone https://github.com/sunfounder/pm_dashboard.git
git clone https://github.com/sunfounder/pm_auto.git
git clone https://github.com/sunfounder/sf_rpi_status.git
```

Make adjustments, and manually install the package

```bash
cd ~/pironman5 && sudo /opt/pironman5/venv/bin/pip3 uninstall pironman5 -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/pm_dashboard && sudo /opt/pironman5/venv/bin/pip3 uninstall pm_dashboard -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/pm_auto && sudo /opt/pironman5/venv/bin/pip3 uninstall pm_auto -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
cd ~/sf_rpi_status && sudo /opt/pironman5/venv/bin/pip3 uninstall sf_rpi_status -y && sudo /opt/pironman5/venv/bin/pip3 install . --no-build-isolation
```

Start/stop the service for debug

```
sudo systemctl stop pironman5.service
sudo systemctl start pironman5.service
sudo systemctl restart pironman5.service
sudo pironman5 start

sudo /opt/pironman5/venv/bin/python3
```

## About SunFounder

SunFounder is a company focused on STEAM education with products like open source robots, development boards, STEAM kit, modules, tools and other smart devices distributed globally. In SunFounder, we strive to help elementary and middle school students as well as hobbyists, through STEAM education, strengthen their hands-on practices and problem-solving abilities. In this way, we hope to disseminate knowledge and provide skill training in a full-of-joy way, thus fostering your interest in programming and making, and exposing you to a fascinating world of science and engineering. To embrace the future of artificial intelligence, it is urgent and meaningful to learn abundant STEAM knowledge.

## Contact us

website:
    www.sunfounder.com

E-mail:
    service@sunfounder.com
