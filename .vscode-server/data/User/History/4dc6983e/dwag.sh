#!/bin/bash

# Function to display menu
show_menu() {
  echo "============================="
  echo "       GIT OPERATIONS        "
  echo "============================="
  echo "1. Initialize a Git repository"
  echo "2. Add remote origin"
  echo "3. Check current branch"
  echo "4. Create and switch to a new branch"
  echo "5. Fetch and checkout a branch"
  echo "6. Stage all changes"
  echo "7. Commit changes"
  echo "8. Push changes to remote"
  echo "9. Pull changes from remote"
  echo "10. Check repository status"
  echo "11. List all branches"
  echo "12. Delete a branch"
  echo "13. Reset repository"
  echo "14. Clone a repository"
  echo "15. View commit logs"
  echo "0. Exit"
  echo "============================="
}

# Function definitions for each operation
init_git_repo() {
  if [ -d ".git" ]; then
    echo "[INFO] Git is already initialized in this directory."
  else
    git init && echo "[INFO] Git repository initialized successfully." || echo "[ERROR] Failed to initialize Git repository."
  fi
}

add_remote_origin() {
  read -p "Enter the GitHub repository URL (e.g., git@github.com:username/repo.git): " REMOTE_URL
  if git remote | grep -q "origin"; then
    echo "[INFO] Remote origin already exists. Current URL:"
    git remote get-url origin
  else
    git remote add origin "$REMOTE_URL" && echo "[INFO] Remote origin added successfully." || echo "[ERROR] Failed to add remote origin."
  fi
}

check_current_branch() {
  BRANCH=$(git branch --show-current)
  if [ -n "$BRANCH" ]; then
    echo "[INFO] You are on branch: $BRANCH"
  else
    echo "[ERROR] Failed to retrieve current branch or not in a Git repository."
  fi
}

create_new_branch() {
  read -p "Enter the name of the new branch: " BRANCH
  if git branch | grep -q "$BRANCH"; then
    echo "[INFO] Branch '$BRANCH' already exists. Switching to it..."
    git checkout "$BRANCH"
  else
    git checkout -b "$BRANCH" && echo "[INFO] New branch '$BRANCH' created and switched to it." || echo "[ERROR] Failed to create new branch."
  fi
}

fetch_and_checkout() {
  read -p "Enter the name of the branch to fetch and checkout: " BRANCH
  git fetch origin "$BRANCH" && git checkout "$BRANCH" && echo "[INFO] Fetched and switched to branch '$BRANCH'." || echo "[ERROR] Failed to fetch or checkout branch."
}

stage_changes() {
  git add . && echo "[INFO] All changes staged successfully." || echo "[ERROR] Failed to stage changes."
}

commit_changes() {
  read -p "Enter commit message: " MESSAGE
  if [ -z "$MESSAGE" ]; then
    echo "[ERROR] Commit message cannot be empty."
  else
    git commit -m "$MESSAGE" && echo "[INFO] Changes committed successfully." || echo "[ERROR] Failed to commit changes."
  fi
}

push_changes() {
  read -p "Enter the branch name to push to: " BRANCH
  git push origin "$BRANCH" && echo "[INFO] Changes pushed to branch '$BRANCH'." || echo "[ERROR] Failed to push changes."
}

pull_changes() {
  git pull && echo "[INFO] Changes pulled successfully." || echo "[ERROR] Failed to pull changes."
}

check_git_status() {
  git status
}

list_branches() {
  echo "[INFO] Listing all branches:"
  git branch -a
}

delete_branch() {
  read -p "Enter the branch name to delete: " BRANCH
  git branch -d "$BRANCH" && echo "[INFO] Branch '$BRANCH' deleted successfully." || echo "[ERROR] Failed to delete branch."
}

reset_repository() {
  read -p "Enter the commit hash to reset to (or leave empty for latest): " COMMIT
  if [ -z "$COMMIT" ]; then
    git reset --hard HEAD && echo "[INFO] Repository reset to latest state." || echo "[ERROR] Failed to reset repository."
  else
    git reset --hard "$COMMIT" && echo "[INFO] Repository reset to commit '$COMMIT'." || echo "[ERROR] Failed to reset repository to commit."
  fi
}

clone_repo() {
  read -p "Enter the GitHub repository URL: " REPO_URL
  git clone "$REPO_URL" && echo "[INFO] Repository cloned successfully." || echo "[ERROR] Failed to clone repository."
}

view_logs() {
  git log --oneline --graph --decorate --all
}

# Main menu loop
while true; do
  show_menu
  read -p "Select an operation (0 to exit): " CHOICE
  case $CHOICE in
    1) init_git_repo ;;
    2) add_remote_origin ;;
    3) check_current_branch ;;
    4) create_new_branch ;;
    5) fetch_and_checkout ;;
    6) stage_changes ;;
    7) commit_changes ;;
    8) push_changes ;;
    9) pull_changes ;;
    10) check_git_status ;;
    11) list_branches ;;
    12) delete_branch ;;
    13) reset_repository ;;
    14) clone_repo ;;
    15) view_logs ;;
    0) echo "[INFO] Exiting script. Goodbye!" && exit 0 ;;
    *) echo "[ERROR] Invalid choice. Please try again." ;;
  esac
  echo "================================="
done