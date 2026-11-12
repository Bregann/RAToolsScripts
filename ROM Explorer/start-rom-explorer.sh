#!/usr/bin/env bash
# ROM Explorer for Linux (and macOS): run  ./start-rom-explorer.sh   (extra options go to romx, e.g. --port 9000 --no-browser)
# The first start makes a private Python environment in .venv here and installs ROM Explorer's parts into it.
set -u
cd "$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")" || exit 1

PY=""
for c in python3 python; do
  if command -v "$c" >/dev/null 2>&1 && "$c" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then
  echo
  echo " ROM Explorer needs Python 3.10 or newer. Install it with your package manager, for example:"
  echo "   Ubuntu/Debian:  sudo apt install python3 python3-venv"
  echo "   Fedora:         sudo dnf install python3"
  echo "   Arch:           sudo pacman -S python"
  echo
  exit 1
fi

if [ ! -x .venv/bin/python ]; then
  echo " Setting up ROM Explorer's Python environment (first start only)..."
  if ! "$PY" -m venv .venv; then
    rm -rf .venv
    echo
    echo " Couldn't create a Python environment. On Ubuntu/Debian install the venv module first:"
    echo "   sudo apt install python3-venv"
    echo " then run this again."
    exit 1
  fi
fi
VPY=.venv/bin/python

echo " Checking ROM Explorer's parts (the first time this downloads a few things)..."
"$VPY" -m pip install -q --disable-pip-version-check -r requirements.txt \
  || echo " Some parts didn't install. ROM Explorer will show what's missing on its Setup page."
echo
exec "$VPY" -m romx "$@"
