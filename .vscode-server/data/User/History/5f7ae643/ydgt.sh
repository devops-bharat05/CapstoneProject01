#!/bin/bash

# Function to display error and exit
error_exit() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Step 1: Install Git if not already installed
echo "[INFO] Checking for Git installation..."
if ! command -v git &>/dev/null; then
  echo "[INFO] Git not found. Installing Git..."
  sudo apt update -y || error_exit "Failed to update package list."
  sudo apt install git -y || error_exit "Failed to install Git."
else
  echo "[INFO] Git is already installed."
fi

# Step 2: Configure SSH keys for GitHub authentication
echo "[INFO] Setting up SSH keys for GitHub..."
SSH_KEY_PATH=~/.ssh/id_rsa
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "[INFO] SSH key not found. Generating a new SSH key..."
  ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -f "$SSH_KEY_PATH" -N "" || error_exit "Failed to generate SSH key."
  echo "[INFO] Public key generated. Add the following key to your GitHub account under SSH keys:"
  cat "$SSH_KEY_PATH.pub"
  echo -e "\n[INFO] Open https://github.com/settings/keys to add the SSH key. Press Enter once done."
  read -r
else
  echo "[INFO] SSH key already exists. Skipping key generation."
  echo "[INFO] Ensure the following public key is added to your GitHub account under SSH keys:"
  cat "$SSH_KEY_PATH.pub"
  echo -e "\n[INFO] Open https://github.com/settings/keys to verify or add the SSH key. Press Enter once done."
  read -r
fi

# Step 3: Test SSH connection to GitHub
echo "[INFO] Testing SSH connection to GitHub..."
SSH_TEST_OUTPUT=$(ssh -T git@github.com 2>&1)
if [[ "$SSH_TEST_OUTPUT" == *"successfully authenticated"* ]]; then
  echo "[INFO] SSH authentication successful."
else
  echo "$SSH_TEST_OUTPUT"
  error_exit "SSH authentication failed. Ensure the key is added to GitHub."
fi

# Step 4: Prompt user for repository and branch details
read -p "Enter the GitHub repository (e.g., username/repo): " REPO
[ -z "$REPO" ] && error_exit "Repository cannot be empty."

read -p "Enter the branch name to fetch: " BRANCH
[ -z "$BRANCH" ] && error_exit "Branch name cannot be empty."

# Step 5: Clone or fetch the specific branch
echo "[INFO] Cloning or fetching branch '$BRANCH' from repository '$REPO'..."
REPO_DIR=$(basename "$REPO" .git)
if [ ! -d "$REPO_DIR" ]; then
  git clone -b "$BRANCH" "git@github.com:$REPO.git" || error_exit "Failed to clone repository."
else
  cd "$REPO_DIR" || error_exit "Failed to enter repository directory."
  git fetch origin "$BRANCH" || error_exit "Failed to fetch branch."
  git checkout "$BRANCH" || error_exit "Failed to checkout branch."
fi

echo "[INFO] Branch '$BRANCH' is successfully fetched and checked out."
exit 0