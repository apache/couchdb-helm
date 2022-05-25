#!/usr/bin/env bash

set -euxo pipefail

echo '--> Clearing past inventory.txt'
rm -f inventory.txt

echo '--> Building inventory.txt with files and commits'

# generate the list of backfill commits
# assuming that the commit that added the tarball also has the appropriate state committed to the repo
for f in `ls . | grep -v '.*backfill.*' | grep -v '.*inventory.*' | grep -v '.*index.*'`; do echo $f: `git log --oneline -- $f | head -1` >> inventory.txt; done

echo '--> Done!'
