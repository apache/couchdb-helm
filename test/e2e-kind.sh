#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly CT_VERSION=v3.8.0
readonly KIND_VERSION=v0.18.0
readonly CLUSTER_NAME=chart-testing
readonly K8S_VERSION=v1.25.3

run_ct_container() {
    echo 'Running ct container...'
    docker run --rm --interactive --detach --network host --name ct \
        --volume "$(pwd)/test/ct.yaml:/etc/ct/ct.yaml" \
        --volume "$(pwd):/workdir" \
        --workdir /workdir \
        "quay.io/helmpack/chart-testing:$CT_VERSION" \
        cat
    echo
}

cleanup() {
    echo 'Removing ct container...'
    docker kill ct > /dev/null 2>&1

    kind delete cluster --name "$CLUSTER_NAME" || true

    echo 'Done!'
}

docker_exec() {
    docker exec --interactive ct "$@"
}

create_kind_cluster() {
    if ! [ -x "$(command -v kind)" ]; then
        echo 'kind not found. See https://kind.sigs.k8s.io/ for installation instructions.'
        exit
    fi

    kind delete cluster --name "$CLUSTER_NAME" || true
    kind create cluster --name "$CLUSTER_NAME" --config test/kind-config.yaml --image "kindest/node:$K8S_VERSION" --wait 60s

    docker_exec mkdir -p /root/.kube

    echo 'Copying kubeconfig to container...'
    local kubeconfig=$(mktemp)
    kind get kubeconfig --name "$CLUSTER_NAME" >"$kubeconfig"
    docker cp "$kubeconfig" ct:/root/.kube/config
    rm "$kubeconfig"

    docker_exec kubectl cluster-info
    echo

    docker_exec kubectl get nodes
    echo

    echo 'Cluster ready!'
    echo
}

install_charts() {
    docker_exec ct lint-and-install --charts couchdb --upgrade --chart-dirs .
    echo
}

main() {
    run_ct_container
    trap cleanup EXIT

    create_kind_cluster
    install_charts
}

main
