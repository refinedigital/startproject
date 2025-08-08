#!/bin/zsh
# File: ~/scripts/start_project.sh 
# Version: 1.0.5
#
# A script to initialize a new project workspace with Git,
# a README, and a .gitignore.
# Idempotent: Checks if the project is already a Git repository and exits if so.
#
# Make it executable: chmod +x ~/scripts/start_project.sh

# --- Idempotency Check ---
# Exit if this is already a Git repository
if [ -d ".git" ]; then
  echo "ℹ️  This directory is already a Git repository. Exiting."
  exit 1
fi

# --- Get Project Details ---
echo "🚀 Let's start a new project!"
echo "---------------------------------"

# Get the current folder name, convert to lowercase, and remove spaces for the default repo name
CURRENT_DIR_NAME=${PWD##*/}
LOWERCASE_DIR_NAME=$(echo "$CURRENT_DIR_NAME" | tr '[:upper:]' '[:lower:]')
SANITIZED_DIR_NAME="${LOWERCASE_DIR_NAME// /}"

read "REPO_NAME?Enter your repository name (Default: $SANITIZED_DIR_NAME): "
REPO_NAME=${REPO_NAME:-$SANITIZED_DIR_NAME}

# --- REPO_OWNER Selection ---
while true; do
  echo "\nSelect the Repository Owner:"
  echo "1) refine-digital (default)"
  echo "2) pilatesvia"
  read "owner_choice?Choice [1]: "

  case $owner_choice in
    "" | 1)
      REPO_OWNER="refine-digital"
      break
      ;;
    2)
      REPO_OWNER="pilatesvia"
      break
      ;;
    *)
      echo "   - Invalid choice. Please try again."
      ;;
  esac
done
echo "   - Repository Owner set to: $REPO_OWNER"

# --- PROJECT_OWNER Selection ---
while true; do
  echo "\nSelect the Project Owner (for SSH config):"
  echo "1) refinedigital (default)"
  echo "2) pilatesvia"
  read "project_owner_choice?Choice [1]: "

  case $project_owner_choice in
    "" | 1)
      PROJECT_OWNER="refinedigital"
      break
      ;;
    2)
      PROJECT_OWNER="pilatesvia"
      break
      ;;
    *)
      echo "   - Invalid choice. Please try again."
      ;;
  esac
done
echo "   - Project Owner set to: $PROJECT_OWNER"

read "COMMIT_MESSAGE?Enter the initial commit message (Ex. Start New Project): "

# --- Git Initialization ---
echo "\n🔧 Initializing Git repository..."
git init
git branch -M main

# --- Create Default Files ---
echo "📄 Creating or updating default files..."

# Check for README.md
if [ ! -f "README.md" ]; then
    echo "   - Creating README.md..."
    echo "# $REPO_NAME" > README.md
    echo "Created by $REPO_OWNER" >> README.md
else
    echo "   - README.md already exists, skipping."
fi

# Define default .gitignore content
DEFAULT_GITIGNORE="# Default macOS/Node Rules
# -------------------------
# General
.DS_Store
.AppleDouble
.LSOverride

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
# -------------------------\n"

# Check for .gitignore
if [ -f ".gitignore" ]; then
    echo "   - .gitignore exists, prepending default rules..."
    # Prepend default content to existing file
    TEMP_FILE=$(mktemp)
    echo -e "$DEFAULT_GITIGNORE" > "$TEMP_FILE"
    cat .gitignore >> "$TEMP_FILE"
    mv "$TEMP_FILE" .gitignore
else
    echo "   - Creating .gitignore..."
    # Create new file with default content
    echo -e "$DEFAULT_GITIGNORE" > .gitignore
fi

# --- Git Commit ---
echo "💾 Staging files and making initial commit..."
git add .
git commit -m "app: $COMMIT_MESSAGE"

# --- Final Instructions ---
echo "\n✅ All done! Your local project is set up."
echo "---------------------------------"
echo "Next steps:"
echo "1. Go to https://github.com/new and create the repository '$REPO_NAME'."
echo "2. Connect your local repository to the remote by running:"
echo "   git remote add origin git@github.com-${PROJECT_OWNER}:${REPO_OWNER}/${REPO_NAME}.git"
echo "3. Push your initial commit:"
echo "   git push -u origin main"
