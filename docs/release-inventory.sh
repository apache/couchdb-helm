#!/usr/bin/env bash

set -euxo pipefail

# Example usage
#
#
# $1 == owner - no default
# $2 == "execute" makes the release fire!
# $3 == GitHub auth token. Defaults to the value of $GITHUB_PAT
# $4 == GitHub repository - defaults to "couchdb-helm"

owner=${1:-}
execute=${2:-}
token=${3:-${GITHUB_PAT:-}}
repo=${4:-couchdb-helm}
chart_name=${5:-couchdb}

if [[ -z "$owner" ]]; then
  echo "Error: must provide 'owner' in first argument"
  exit 1
fi

echo "Owner: $owner"
echo "Execute?: $execute"

IFS_OLD=$IFS
trap 'IFS=$IFS_OLD' EXIT SIGINT
IFS=$'\n'

current_sha=$(git branch --show-current)
res=$?
if [[ $res -gt 0 ]]; then
  current_sha=$(git rev-parse --short HEAD)
fi;
# clean up handler. This warns, but does help escape the loop on interrupt
trap "git checkout $current_sha; exit 1" EXIT SIGINT

inventory=$(cat inventory.txt)
for line in ${inventory}; do
  echo $line;
  tarball=$(echo $line | cut -d: -f 1);
  gitsha=$(echo $line | cut -d' ' -f 2);
  cversion=${tarball/couchdb-/};
  cversion=${cversion/.tgz/};
  echo "--> Checking out '$gitsha' for chart version '$cversion'";

  git checkout $gitsha;

  long_sha=$(git rev-parse $gitsha)

  read -n 1 -p "Pausing to check if this is ok. Press any key to continue: ";
  echo ;
  echo "--> Continuing...";
  echo; echo;

  if [[ "$execute" == "execute" ]] && [[ -n "$token" ]]; then
    echo "--> Setting tag for release ${cversion} and sha ${gitsha}!"
    git tag -f ${chart_name}-${cversion}
    echo "--> Executing release!"
    ./bin/cr package ../couchdb
    ./bin/cr upload -c "$long_sha" --skip-existing -t "$token" -o $owner -r $repo
    git push --tags --force
    # clean the directory
    rm .cr-release-packages/*
  else
    echo "--> 'execute' was not provided to the .sh invocation. Skipping..."
  fi

done

git checkout $current_sha
exit 0
