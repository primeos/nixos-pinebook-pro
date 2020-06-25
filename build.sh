#!/usr/bin/env bash

PS4=" $ "
set -eux

export NIXPKGS_ALLOW_UNFREE=1
nix-build system.nix -A config.system.build.sdImage "$@"
