#!/usr/bin/env bash

set -euo pipefail

function configDir() {
  local configDir=~/.config/matrixc
  mkdir -p "$configDir"
  echo "$configDir"
}

function requestToken() {
  echo "username: "
  read -r username
  echo "password: "
  read -rs password

  resp=$(curl -fsSL -XPOST \
    -d "{\"type\":\"m.login.password\",\"user\":\"${username}\",\"password\":\"${password}\"}" \
    "https://matrix.org/_matrix/client/r0/login")
  token=$(echo "$resp" | jq -r .access_token)

  echo "$token" >"$(configDir)/token"
}

function readToken() {
  cat "$(configDir)/token"
}

function addRoom() {
  echo "Room ID: "
  read -r roomId
  echo "Room alias: "
  read -r roomAlias

  echo "$roomAlias $roomId" >>"$(configDir)/rooms"
}

function readRoom() {
  roomAlias=$1
  grep "$roomAlias" "$(configDir)/rooms" | cut -d' ' -f2
}

function send() {
  roomAlias=$1
  message=$2

  roomId=$(readRoom "$roomAlias")
  token=$(readToken)

  curl -fsSL -XPOST \
    -d "{\"msgtype\":\"m.text\",\"body\":\"${message}\"}" \
    "https://matrix.org/_matrix/client/r0/rooms/${roomId}/send/m.room.message?access_token=${token}" >/dev/null
}

function main() {
  case "${1:-}" in
  "login")
    requestToken
    ;;
  "add-room")
    addRoom
    ;;
  "send")
    shift
    send "$@"
    ;;
  *)
    echo "Usage: matrixc <login|add-room|send <room-alias> <message>>"
    exit 1
    ;;
  esac
}

main "$@"
