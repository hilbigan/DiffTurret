#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname $0)"

MESSAGE_BYTE_LIMIT=1900

# discord.env must set environment variables like so:
# DISCORD_TOKEN="..."
# DISCORD_CHANNEL="..."
[ -e "discord.env" ] || (echo "Missing discord.env!"; exit 1)
source discord.env

mkdir -p cache

WEBSITE="$1"
PATTERN="${2:-}"

function hash() {
    echo "${WEBSITE}${PATTERN}" | sha256sum | head -c12
}

FILENAME="cache/$(hash).cache"

function load_site() {
    curl -s "$WEBSITE" | grep -E "$PATTERN" > $FILENAME
}

if [ -e "$FILENAME" ]; then
    mv "$FILENAME" "$FILENAME.old"
    load_site
    set +e # allow non-zero exit codes
    diff -u -W80 "$FILENAME" "$FILENAME.old" > /dev/null
    DIFF=$?
    set -e # end
    if [ $DIFF -ne 0 ]; then
        TMP="$(mktemp)"
        echo "Site $WEBSITE has changed:" > $TMP
        echo '```diff' >> $TMP
        set +e # allow non-zero exit codes
        diff -u -W80 "$FILENAME.old" "$FILENAME" | head -c $MESSAGE_BYTE_LIMIT >> $TMP
        set -e # end
        echo '```' >> $TMP
        cat "$TMP" | ./notify.py $DISCORD_TOKEN $DISCORD_CHANNEL
        rm "$TMP"
    fi
    echo "$FILENAME"
else
    load_site
fi
