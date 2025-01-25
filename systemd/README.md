# Setup with systemd, e.g. on ubuntu or rasbberry pi with raspbian

## Make user with right permissions

```bash
sudo useradd -d /opt/webscale -m -G dialout -s /bin/bash webscale
```

## Clone this repository

```bash
git clone git@github.com:phokz/webscale.git
```

## Install dependencies

```bash
apt-get -y install ruby-dev build-essential
gem install bundler
cd webscale
bundle install
```

## Configure systemd unit file

```bash
editor webscale.service
sudo cp webscale.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start webscale
sudo systemctl status webscal
```

