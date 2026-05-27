# Pironman 5 - Arch Linux Fork (Endeavour)

Pironman 5 case - Arch Linux compatible fork

Quick Links:

- [Pironman 5](#pironman-5---arch-linux-fork-endeavour)
  - [About Pironman5](#about-pironman5)
  - [Links](#links)
  - [Installation](#installation)
  - [Auto launch dashboard on browser](#auto-launch-dashboard-on-browser)
  - [Update](#update)
  - [Compatible Systems](#compatible-systems)
    - [Debug](#debug)
  - [About SunFounder](#about-sunfounder)
  - [Contact us](#contact-us)

## About Pironman5

## Links

- SunFounder Online Store &emsp; <https://www.sunfounder.com/>
- Documentation &emsp; <https://docs.sunfounder.com/projects/pironman5/en/latest/>

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

## Auto launch dashboard on browser

```bash
pironman5 launch-browser --auto-start=on
```

You also want to change touchscreen mode to Multitouch instead of Mouse Emulation.

1. **Raspberry Pi Icon** >> **Preferences** >> **Control Centre**.
2. Select **Screen** tab.
3. Long press/right click on **DSI-2**, 
4. Select **Touchscreen** >> **Mode** >> **Multitouch**.

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
# install from folder
sudo /opt/pironman5/venv/bin/pip3 uninstall pironman5 -y && sudo /opt/pironman5/venv/bin/pip3 install ~/pironman5 --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pm_dashboard -y && sudo /opt/pironman5/venv/bin/pip3 install ~/pm_dashboard --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pm_auto -y && sudo /opt/pironman5/venv/bin/pip3 install ~/pm_auto --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall sf_rpi_status -y && sudo /opt/pironman5/venv/bin/pip3 install ~/sf_rpi_status --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pipower5 -y && sudo /opt/pironman5/venv/bin/pip3 install ~/pipower5 --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5

# install from github repo
sudo /opt/pironman5/venv/bin/pip3 uninstall sf_rpi_status -y && sudo /opt/pironman5/venv/bin/pip3 install git+https://github.com/sunfounder/sf_rpi_status.git --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pipower5 -y && sudo /opt/pironman5/venv/bin/pip3 install git+https://github.com/sunfounder/pipower5.git --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pm_auto -y && sudo /opt/pironman5/venv/bin/pip3 install git+https://github.com/sunfounder/pm_auto.git@1.4.x --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
sudo /opt/pironman5/venv/bin/pip3 uninstall pm_dashboard -y && sudo /opt/pironman5/venv/bin/pip3 install git+https://github.com/sunfounder/pm_dashboard.git@1.3.x --no-build-isolation && sudo chown -R pironman5:pironman5 /opt/pironman5
```


Start/stop the service for debug

```bash
sudo systemctl stop pironman5.service
sudo systemctl start pironman5.service
sudo systemctl restart pironman5.service
sudo -u pironman5 /opt/pironman5/venv/bin/python3

journalctl -xefu pironman5.service
sudo systemctl restart pironman5.service && journalctl -xefu pironman5.service
```

## About SunFounder

SunFounder is a company focused on STEAM education with products like open source robots, development boards, STEAM kit, modules, tools and other smart devices distributed globally. In SunFounder, we strive to help elementary and middle school students as well as hobbyists, through STEAM education, strengthen their hands-on practices and problem-solving abilities. In this way, we hope to disseminate knowledge and provide skill training in a full-of-joy way, thus fostering your interest in programming and making, and exposing you to a fascinating world of science and engineering. To embrace the future of artificial intelligence, it is urgent and meaningful to learn abundant STEAM knowledge.

## Contact us

website:
    www.sunfounder.com

E-mail:
    service@sunfounder.com
