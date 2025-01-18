#!/bin/bash

# Function to display an error and exit
error_exit() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Step 1: Check if Git is initialized in the current folder
echo "[INFO] Checking for Git initialization..."
if [ ! -d ".git" ]; then
  echo "[INFO] Git is not initialized in this folder. Initializing now..."
  git init || error_exit "Failed to initialize Git repository."
else
  echo "[INFO] Git is already initialized."
fi

# Step 2: Check for remote origin
echo "[INFO] Checking for remote repository..."
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE_URL" ]; then
  read -p "Enter the GitHub repository URL (e.g., git@github.com:username/repo.git): " REMOTE_URL
  [ -z "$REMOTE_URL" ] && error_exit "Repository URL cannot be empty."
  git remote add origin "$REMOTE_URL" || error_exit "Failed to add remote repository."
else
  echo "[INFO] Remote repository is already set: $REMOTE_URL"
fi

# Step 3: Prompt user for branch name
read -p "Enter the branch name to push to: " BRANCH
[ -z "$BRANCH" ] && error_exit "Branch name cannot be empty."

# Step 4: Check out the branch or create it
echo "[INFO] Checking out branch '$BRANCH'..."
if git show-ref --verify --quiet refs/heads/"$BRANCH"; then
  git checkout "$BRANCH" || error_exit "Failed to checkout branch."
else
  git checkout -b "$BRANCH" || error_exit "Failed to create and checkout branch."
fi

# Step 5: Stage, commit, and push changes
echo "[INFO] Staging changes..."
git add . || error_exit "Failed to stage changes."

read -p "Enter a commit message: " COMMIT_MSG
[ -z "$COMMIT_MSG" ] && error_exit "Commit message cannot be empty."

echo "[INFO] Committing changes..."
git commit -m "$COMMIT_MSG" || error_exit "Failed to commit changes."

echo "[INFO] Pushing changes to branch '$BRANCH'..."
git push -u origin "$BRANCH" || error_exit "Failed to push changes."

echo "[INFO] Code successfully pushed to '$BRANCH' on remote repository."
exit 0