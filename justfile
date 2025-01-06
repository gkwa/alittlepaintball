set shell := ["bash", "-uec"]

default:
    @just --list

setup:
    #!/usr/bin/env bash
    packer init .

    if ! incus image info alittlepaintball-homebrew &>/dev/null; then
        echo "Building base image alittlepaintball-homebrew..."
        packer build -on-error=abort 001-homebrew.pkr.hcl
    fi

    if ! incus image info alittlepaintball-homebrew-configured &>/dev/null; then
        echo "Building configured image alittlepaintball-homebrew-configured..."
        packer build -on-error=abort 002-homebrew-configured.pkr.hcl
    fi

    # Clean up existing containers
    incus info alittlepaintball-homebrew &>/dev/null && incus rm --force alittlepaintball-homebrew
    incus info alittlepaintball-homebrew-configured &>/dev/null && incus rm --force alittlepaintball-homebrew-configured

    terraform init
    terraform plan -out=tfplan
    terraform apply tfplan

    # Test that brew command runs as expected with example app chamber
    incus exec alittlepaintball-homebrew-configured -- bash -l -c 'brew install chamber'
    incus exec alittlepaintball-homebrew-configured -- bash -l -c 'chamber version'

teardown:
    #!/usr/bin/env bash
    set -e

    # Clean up existing containers
    incus info alittlepaintball-homebrew-configured &>/dev/null && incus rm --force alittlepaintball-homebrew-configured
    incus info alittlepaintball-homebrew &>/dev/null && incus rm --force alittlepaintball-homebrew

    # Clean up existing images
    incus image info alittlepaintball-homebrew &>/dev/null && incus image rm alittlepaintball-homebrew
    incus image info alittlepaintball-homebrew-configured &>/dev/null && incus image rm alittlepaintball-homebrew-configured
