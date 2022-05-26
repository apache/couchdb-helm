#!/usr/bin/env bash

os=$(uname -p)
arch=$(uname -s)
if [[ "${os}" == "arm" ]] && [[ "${arch}" == "Darwin" ]]; then
  mkdir -p ./bin/cr-1.4.0/
  curl -L https://github.com/helm/chart-releaser/releases/download/v1.4.0/chart-releaser_1.4.0_darwin_arm64.tar.gz | tar -xzvf - -C ./bin/cr-1.4.0/
  ln -f -s $PWD/bin/cr-1.4.0/cr $PWD/bin/cr
  echo "Installed successfully!"
else
  echo "ERROR: OS '${os}' and Architecture '${arch}' not defined"
  echo "Visit https://github.com/helm/chart-releaser/releases to see releases"
fi
