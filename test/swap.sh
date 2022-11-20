#!/usr/bin/env bash
cd $(dirname $0)
TMP=$(mktemp)
mv a.html "$TMP"
mv b.html a.html 
mv "$TMP" b.html
