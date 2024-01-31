# git-provisioner Docker App

`git-provisioner` is a Docker application designed to clone Git repositories into a Docker volume and periodically pull updates based on environment variables. This tool is particularly useful for dynamically updating configuration files in containerized environments, such as Kubernetes or Docker Swarm, where direct file system access is limited.

## Features
- Clone any Git repository into a specified Docker volume.
- Periodically update the repository based on a configurable interval.
- Environment variables for easy repository and update interval configuration.

## Usage
Set the `REPO_URL` environment variable to your Git repository's URL and `UPDATE_INTERVAL` (in seconds) for how often to check for updates. Mount a Docker volume to `/repo` to store the repository's contents.

