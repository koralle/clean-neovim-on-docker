# Variables
podman := "podman"
build_jobs := "8"
build_memory := "2048m"
build_file := "containers/neovim/Dockerfile"
build_image_name := "koralle-mgmg.com/neovim"
build_image_tag := "latest"
build_image_id := build_image_name + ":" + build_image_tag
nvim_container_name := "neovim"

# Aliases
alias b := build
alias r := run
alias at := attach

# Recipes

# Build the container with Podman.
build:
    {{podman}} build \
        --arch={{arch()}} \
        --jobs={{build_jobs}} \
        -m={{build_memory}} \
        -f ./{{build_file}} \
        --ignorefile .dockerignore \
        -t {{build_image_id}} \
        .

# Run the container with Podman.
run:
    just clean
    {{podman}} run \
        -itd \
        --name {{nvim_container_name}} \
        {{build_image_id}} \
        /bin/bash

# Attach the container with Podman.
attach:
    -{{podman}} exec -it {{nvim_container_name}} /bin/bash

# Lint the Containerfile with Hadolint.
lint:
    hadolint {{build_file}}

clean:
    {{podman}} rm -f {{nvim_container_name}}
