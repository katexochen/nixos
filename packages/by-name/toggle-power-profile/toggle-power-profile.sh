#!/usr/bin/env bash

set -euo pipefail

case "$(powerprofilesctl get)" in
"power-saver")
  powerprofilesctl set performance
  ;;
"performance")
  powerprofilesctl set balanced
  ;;
"balanced")
  powerprofilesctl set power-saver
  ;;
*)
  powerprofilesctl set power-saver
  ;;
esac
