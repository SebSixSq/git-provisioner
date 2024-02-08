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

# Define the directory where the repository is cloned
CLONE_DIR="/repo"

# File to store the last used REPO_URL
REPO_URL_FILE="${CLONE_DIR}/.last_repo_url"

# Function to clone the repository
clone_repo() {
    # Clearing existing content before cloning
    echo "Clearing existing content in ${CLONE_DIR}..."
    find "${CLONE_DIR}" -mindepth 1 -exec rm -rf {} +
    
    echo "Cloning repository..."
    if git clone --branch "${REPO_BRANCH}" "${REPO_URL}" "${CLONE_DIR}"; then
        echo "${REPO_URL}" > "${REPO_URL_FILE}"
    else
        echo "Error cloning repository. Check REPO_URL and REPO_BRANCH."
        exit 1
    fi
}

# Function to update the repository
update_repo() {
    echo "Updating repository..."
    if ! git -C "${CLONE_DIR}" pull origin "${REPO_BRANCH}"; then
        echo "Error updating repository. Attempting to re-clone..."
        clone_repo
    fi
}

# Initial clone or update
if [ -f "${REPO_URL_FILE}" ]; then
    LAST_REPO_URL=$(cat "${REPO_URL_FILE}")
    if [ "${LAST_REPO_URL}" != "${REPO_URL}" ]; then
        echo "REPO_URL has changed. Re-cloning repository..."
        clone_repo
    else
        update_repo
    fi
else
    clone_repo
fi

# Loop to check for updates if UPDATE_INTERVAL is not 0
while [ $UPDATE_INTERVAL -ne 0 ]; do
    sleep "$UPDATE_INTERVAL"
    update_repo
done

# Keep the container running if UPDATE_INTERVAL is 0
if [ $UPDATE_INTERVAL -eq 0 ]; then
    tail -f /dev/null
fi
