# trojan-quickstart

A simple installation script for trojan server.

This script will help you install the trojan binary to `/usr/local/bin`, a template for server configuration to `/usr/local/etc/trojan`, and (if applicable) a systemd service to `/etc/systemd/system`. It only works on `linux-amd64` machines.

## Usage

- via `curl`
    ```
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
    ```
- via `wget`
    ```
    sudo sh -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
    ```
