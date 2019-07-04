#!/bin/bash

set -e

if [[ $(id -u) != 0 ]]; then
    echo Please run this script as root.
    exit 1
fi

NAME=trojan
VERSION=1.12.3
TARBALL=$NAME-$VERSION-linux-amd64.tar.xz
DOWNLOADURL=https://github.com/trojan-gfw/$NAME/releases/download/v$VERSION/$TARBALL
TMPDIR=$(mktemp -d)
INSTALLPREFIX=/usr/local
SYSTEMDPREFIX=/etc/systemd/system

echo Entering temp directory $TMPDIR...
cd $TMPDIR

echo Downloading $NAME $VERSION...
curl -LO $DOWNLOADURL || wget $DOWNLOADURL

echo Unpacking $NAME $VERSION...
tar xf $TARBALL
cd $NAME

echo Installing $NAME $VERSION to $INSTALLPREFIX/bin...
install -Dm755 $NAME $INSTALLPREFIX/bin/$NAME

echo Installing $NAME server config to $INSTALLPREFIX/etc/$NAME...
install -Dm644 examples/server.json-example $INSTALLPREFIX/etc/$NAME/config.json

if [[ -e $SYSTEMDPREFIX ]]; then
    echo Installing $NAME systemd service to $SYSTEMDPREFIX...
    cat > $NAME.service << EOF
[Unit]
Description=trojan
Documentation=https://trojan-gfw.github.io/trojan/config https://trojan-gfw.github.io/trojan/
After=network.target network-online.target nss-lookup.target mysql.service mariadb.service mysqld.service

[Service]
Type=simple
StandardError=journal
ExecStart=/usr/local/bin/trojan /usr/local/etc/trojan/config.json
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF
    install -Dm644 $NAME.service $SYSTEMDPREFIX/$NAME.service

    echo Reloading systemd daemon...
    systemctl daemon-reload
fi

echo Deleting temp directory $TMPDIR...
rm -rf $TMPDIR

echo Done!
