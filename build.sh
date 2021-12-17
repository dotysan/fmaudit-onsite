#! /usr/bin/env bash
#
set -ex

main() {
    case "$1" in
        build) build ;;
        run) run ;;
    esac
}

build() {
    docker build --progress=plain -t fmaudit .
}

run() {
    docker run -d -p 33330:33330 \
      --tmpfs=/run --tmpfs=/tmp \
      --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
      --name fmaudit fmaudit
}

main "$1"
exit 0
