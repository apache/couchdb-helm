#!/usr/bin/env bash

# Run this script from the root of the helm repo, e.g.,
# ./scripts/rebuild.sh. You must have curl and cr installed. See
# https://github.com/helm/chart-releaser#installation.

# Set this to a valid URL *without* an index.yaml if you want to regenerate
# a new index.html. If you want to append to an existing one, you can
# use a real address like `https://apache.github.io/couchdb-helm`. If an existing
# index.yaml is found at this URL, then any packages we generate will
# be appended, which can result in duplicates.
HELM_REPO=${HELM_REPO:-https://apache.github.io}

# Create a temporary directory and clean it up when we're done.
TMP_DIR=$(mktemp -d)
function cleanup()
{
    echo "Removing temporary directory ${TMP_DIR}."
    rm -rf $TMP_DIR
}
trap cleanup EXIT

# Optional variables you can define in your env
PACKAGE_DIR=${PACKAGE_DIR:-${TMP_DIR}}
CHARTS_DIR=${CHARTS_DIR:-charts}
INDEX=${INDEX:-index.yaml}
GITHUB_OWNER=${GITHUB_OWNER:-apache}
GITHUB_REPO=${GITHUB_REPO:-couchdb-helm}

# Calculated variables
DOWNLOADS_BASE="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/releases/download"

# List all tags oldest to newest, followed by the 'main' branch.
tags="$(git tag -l  --sort=creatordate) main"

# Clean the packages release directory that `cr` uses.
mkdir -p ${PACKAGE_DIR}
rm -rf ${PACKAGE_DIR}/*

# Download existing assets from Github
for tag in $tags; do
  dl_url="${DOWNLOADS_BASE}/${tag}/${tag}.tgz"
  cd ${PACKAGE_DIR}
  curl -LOs --fail ${dl_url}
  result=$?
  if [[ ${result} -eq 0 ]]; then
    echo "Downloaded $dl_url".
  else
    echo "Could not download $dl_url".
  fi
  cd -
done

echo "Writing index to ${INDEX}"
rm ${INDEX}
cr index --owner ${GITHUB_OWNER} --git-repo ${GITHUB_REPO} --charts-repo ${HELM_REPO} -p ${PACKAGE_DIR} -i ${INDEX}
