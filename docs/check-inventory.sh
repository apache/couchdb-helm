#!/usr/bin/env bash

set -euxo pipefail

found_probs=0
cat inventory.txt | while read line; do
  tarball=$(echo $line | cut -d: -f 1)
  gitsha=$(echo $line | cut -d' ' -f 2)
  cversion=${tarball/couchdb-/}
  cversion=${cversion/.tgz/}
  echo "--> Checking that '$gitsha' matches chart version '$cversion'";
  
  cversion_actual=$(git show $gitsha:../couchdb/Chart.yaml | grep '^version:')
  diff <(echo "$cversion_actual") <(echo "version: $cversion")
  res=$?
  if [[ $res -gt 0 ]]; then
    echo "--> Uh oh! Git SHA '$gitsha' provided version '$cversion_actual', but tarball had '$cversion'"
    found_probs=1
  fi;

  # TODO: could check that file SHAs match w/ the tarballs... but this is a best effort anyways...
done

echo
if [[ found_probs -eq 0 ]]; then
  echo '--> Success! All checks went well!'
else
  echo '--> PROBLEMS FOUND!'
fi
