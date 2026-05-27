#!/usr/bin/env python3

from tools.sf_installer import SF_Installer
from pironman5.version import __version__
from pironman5.variants import NAME, DT_OVERLAYS, PERIPHERALS

PM_AUTO_VERSION = '1.4.7'
DASHBOARD_VERSION = '1.4.0'
SF_RPI_STATUS_VERSION = '1.1.8'
PIPOWER5_VERSION = 'main'

settings = {
    # - Setup venv options if needed, default to []
    'venv_options': [
        '--system-site-packages',
    ],

    # - Build required pacman dependencies, default to []
    # 'build_dependencies': [
    #     'curl', # for influxdb key download
    # ],

    # - Before install scripts, default to []
    'run_scripts_before_install': [
        "umbrel_patch.sh",
    ],

    # - Install from pacman
    'pacman_dependencies': [
        'python',
    ],

    # - Install from pip
    'pip_dependencies': [
        'psutil',
    ],

    # - Install python source code from git
    'python_source': {
        'pironman5': './',
        'pm_auto': f'git+https://github.com/sunfounder/pm_auto.git@{PM_AUTO_VERSION}',
        'sf_rpi_status': f'git+https://github.com/sunfounder/sf_rpi_status.git@{SF_RPI_STATUS_VERSION}',
    },

    # create symbolic links from venv/bin/ to /usr/local/bin/
    'symlinks':
    [
        'pironman5',
    ],

    # - Setup config txt
    # 'config_txt':  {
    #     'dtparam=spi': 'on',
    #     'dtparam=i2c_arm': 'on',
    #     'dtoverlay=gpio-ir,gpio_pin': '13',
    # },

    # add modules
    # sudo nano /etc/modules
    # 'modules': [
    #     "i2c-dev",
    # ],

    # - Autostart settings
    # - Set service filenames
    'service_files': ['pironman5.service'],
    # - Set bin files
    'bin_files': [],

    # - Copy device tree overlay to /boot/overlays
    'dtoverlays': DT_OVERLAYS,
}

ws2812_settings = {
    'run_scripts_before_install': [
        "install_lgpio.sh",
        "fix_kali_gpio_spi.sh",
    ],
    'groups': ['spi', 'gpio'],
    'pip_dependencies': [
        'adafruit-circuitpython-neopixel-spi',
        'adafruit_platformdetect',
        'Adafruit-Blinka==8.59.0',
        'rpi.lgpio',
        'adafruit-circuitpython-typing',
        'Adafruit-PureIO>=1.1.7',
        'pyftdi>=0.40.0',
    ],
}

oled_settings = {
    # - Install from pacman
    'pacman_dependencies': [
        'libjpeg-turbo',
        'freetype2',
        'openjpeg2',
        'kmod',
        'i2c-tools',
    ],
    'pip_dependencies': [
        'Pillow',
        'smbus2',
    ],
    'modules': [
        "i2c-dev",
    ],
}

gpio_settings = {
    # - Before install script, default to {}
    'run_commands_before_install': {
        'Install LGPIO': 'bash scripts/install_lgpio.sh',
    },

    'pacman_dependencies': [],
    # - Install from pip
    'pip_dependencies': [
        'rpi.lgpio',
    ],
    'run_scripts_after_install': [
        "change_rpi.gpio_to_rpi.lgpio.sh",
    ],
}

pi5_power_button_settings = {
    'pacman_dependencies': [
        'base-devel',
        'gcc',
        'python',
    ],
    'groups': ['input'],
    'pip_dependencies': [
        'evdev',
    ],
}

rgb_matrix_settings = {
    'groups': ['i2c'],
    'pip_dependencies': [
        'smbus2',
        'numpy',
    ],
}

dashboard_settings = {
    'groups': ['influxdb'],
    # - Build required apt dependencies, default to []
    'build_dependencies': [
        'curl',
    ],
    'run_commands_before_install': {
        'Setup InfluxDB': 'bash scripts/setup_influxdb.sh',
    },
    'pacman_dependencies': [
        'influxdb',
        'lsof',
    ],
    'python_source': {
        'pm_dashboard': f'git+https://github.com/sunfounder/pm_dashboard.git@{DASHBOARD_VERSION}',
    },
}

pipower5_settings = {
    # Install python packages from source
    'groups': ['i2c', 'pipower5'],
    'python_source': {
        'pipower5': f'git+https://github.com/sunfounder/pipower5.git@{PIPOWER5_VERSION}',
        'spc': f'git+https://github.com/sunfounder/spc.git',
    },
    # Add symbolic links
    'symlinks': [
        'pipower5',
    ],
    # Before install scripts, default to []
    'run_scripts_before_install': [
        "setup_pipower5.sh",
    ],
    # - Copy device tree overlay to /boot/overlays
    'dtoverlays': [
        f'https://github.com/sunfounder/pipower5/raw/refs/heads/main/sunfounder-pipower5.dtbo'
    ],
}

rtl8125_settings = {
    # - Install from apt
    'run_scripts_before_install': [
        "setup_rtl8125.sh",
    ],
}

installer = SF_Installer(
    name='pironman5',
    friendly_name=NAME,
    # - Setup install command description if needed, default to "Installer for {friendly_name}""
    # description='Installer for Pironman 5',
    # - Setup Work Dir if needed, default to /opt/{name}
    # work_dir='/opt/pironman5',
    # - Setup log dir if needed, default to /var/log/{name}
    # log_dir='/var/log/pironman5',
)

installer.parser.add_argument("--disable-dashboard", action='store_true', help="Disable dashboard")
installer.update_settings(settings)
args = installer.parser.parse_args()
if not args.disable_dashboard:
    installer.update_settings(dashboard_settings)
if 'oled' in PERIPHERALS:
    installer.update_settings(oled_settings)
if 'gpio_fan_state' in PERIPHERALS or \
    'vibration_switch' in PERIPHERALS:
    installer.update_settings(gpio_settings)
if 'ws2812' in PERIPHERALS:
    installer.update_settings(ws2812_settings)
if 'pi5_power_button' in PERIPHERALS:
    installer.update_settings(pi5_power_button_settings)
if 'rgb_matrix' in PERIPHERALS:
    installer.update_settings(rgb_matrix_settings)
if 'pipower5' in PERIPHERALS:
    installer.update_settings(pipower5_settings)
if 'rtl8125' in PERIPHERALS:
    installer.update_settings(rtl8125_settings)
installer.main()
