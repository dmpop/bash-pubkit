#!/usr/bin/env bash
if [ ! -x "$(command -v php)" ]; then
    echo "Looks like PHP is not installed on your system. Use the default package manager to install it."
    exit 1
fi
nohup php -S 0.0.0.0:8000 >/dev/null 2>&1 &
xdg-open http://localhost:8000