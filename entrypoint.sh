#!/bin/sh

# Check if the REPO_URL environment variable is set
if [ -z "$REPO_URL" ]; then
    echo "Error: REPO_URL environment variable is not set."
    echo "Usage: docker run -e REPO_URL=<repository-url> <image>"
    exit 1
fi

# Optional: Branch to clone, defaults to 'main' if not specified
REPO_BRANCH=${REPO_BRANCH:-main}

# Interval for checking updates (in seconds), 0 means no automatic updates
UPDATE_INTERVAL=${UPDATE_INTERVAL:-0}

# Function to clone or update the repository
update_repo() {
    if [ ! -d "/repo/.git" ]; then
        echo "Cloning repository..."
        git clone --branch "$REPO_BRANCH" "$REPO_URL" /repo
    else
        echo "Updating repository..."
        git -C /repo pull origin "$REPO_BRANCH"
    fi
}

# Initial clone or update
update_repo

# Loop to check for updates if UPDATE_INTERVAL is not 0
while [ $UPDATE_INTERVAL -ne 0 ]; do
    sleep $UPDATE_INTERVAL
    update_repo
done

# Keep the container running if UPDATE_INTERVAL is 0
if [ $UPDATE_INTERVAL -eq 0 ]; then
    tail -f /dev/null
fi
