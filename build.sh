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
    echo "Don't forget to connect to http://localhost:33330/ and finish the setup."
}

main "$1"
exit 0
