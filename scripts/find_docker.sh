#!/bin/sh

set -e

if command -v podman > /dev/null; then
    echo "podman"
elif command -v docker > /dev/null; then
    echo "docker"
else
    echo "docker command not found." 1>&2
    exit 1
fi
