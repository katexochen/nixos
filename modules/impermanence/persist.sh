#!/usr/bin/env bash

# wl-paste | xargs ./persist.sh

set -euo pipefail

persistDir="/persist"

if [[ -z ${1-} ]]; then
    echo "Persist a path to the persisten subvolume"
    echo
    echo "Usage:"
    echo "  ${0} /path/a [/path/b /path/c ...]"
    exit 0
fi

persist() {
    src=$1
    dst="${persistDir}${src}"
    srcDir=$(dirname "$src")
    dstDir="${persistDir}${srcDir}"

    if [[ -f "$src" ]]; then
        :
    elif [[ -d "$src" ]]; then
        :
    else
        echo "Source '$1' is neither file nor dir"
        return 1
    fi


    sudo mkdir -p "$dstDir"
    sudo mv -n "$src" "$dst"
}

exitcode=0

for arg in "$@"; do
    if persist "$arg"; then
        echo "$arg"
    else
        exitcode=$?
    fi
done

exit $exitcode
