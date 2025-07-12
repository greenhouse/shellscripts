#!/bin/bash

DESCR="
#==================================#
Usage: $0 <github_username> <clone_dir> <old_email> <new_email>
Requirements: gh CLI
Requirements: gh auth login for github users involved in forking/cloning & setting repos to private (step #5 above|below)
IMPORTANT: <github_username> is NOT the gh auth login user that is forking/cloning,
  <github_username> it is the username that owns the repos to be forked/cloned & repos to be set to private
This script forks ALL (public) repositories in the <github_username> organization
Everything is forked privately 
Then the script clones all forked repositories into the <clone_dir> directory
Then it updates the commit emails in each cloned repository using git filter-repo
The <old_email> is replaced with <new_email> in each repository
#==================================#"

SETUP="
#==================================#
# GitHub CLI tool 'gh' w/ ssh access
#==================================#
*** WEB REFERENCES ***
# ref: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# ref: https://github.com/settings/tokens
# ref: https://github.com/settings/keys


*** INSTALL SETUP ***
## 1) generate ssh key locally (requires choosing/entering a <file-name>)
#   note_1: have always been using RSA for years with AWS
#   note_2: can use different size than '4096', like '2048' 
#    (AWS uses even smaller when generating RSA in their portal)
#.  note_3: generates private key with <file-name> & public key with <file-name>.pub
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
	# - OR - 
$ ssh-keygen -t ed25519 -C "your_email@example.com"

## 2.1) add generated private key file to ~/.ssh/
## 2.2) update ~/.ssh/config with ...
host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/<file-name>

## 3) add generated public key to GitHub.com account (data in <file-name>.pub)
# ref: https://github.com/settings/keys
#  note: select key type: 'authentication key'

## 4) install GitHub cli
$ brew install gh
$ gh --version

## 5) login to GitHub 
$ gh auth login
 ? Where do you use GitHub? GitHub.com
 ? What is your preferred protocol for Git operations on this host? SSH
 ? Upload your SSH public key to your GitHub account? Skip
 ? How would you like to authenticate GitHub CLI? Paste an authentication token
 Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
 The minimum required scopes are 'repo', 'read:org'.
 ? Paste your authentication token: ****************************************
 - gh config set -h github.com git_protocol ssh
 ✓ Configured git protocol
 ✓ Logged in as <github_username>
 $
#==================================#"

echo ""
echo "_START INFO_"
echo ""
echo "$DESCR"
echo ""
echo "$SETUP"
echo ""
echo "$DESCR"
echo ""
echo "_END INFO_"
echo ""

#!/bin/bash

# Check if GitHub username, clone directory, old email, and new email are provided
if [ $# -ne 4 ]; then
    echo ""
    echo "Usage: $0 <github_username> <clone_dir> <old_email> <new_email>"
    echo ""
    exit 1
fi

USERNAME="$1"
CLONE_DIR="$2"
OLD_EMAIL="$3"
NEW_EMAIL="$4"

# Ensure gh is authenticated
# if ! gh auth status > /dev/null 2>&1; then
#     echo "Error: Please authenticate with GitHub CLI using 'gh auth login'"
#     exit 1
# fi

# Ensure git filter-repo is installed
if ! command -v git-filter-repo > /dev/null 2>&1; then
    echo ""
    echo "Error: git-filter-repo is not installed. Install it with 'brew install git-filter-repo'"
    echo ""
    exit 1
fi

# Ensure SSH key is loaded (NOTE: this check fails if ssh is added manually to ~/.ssh/config)
if ! ssh-add -l > /dev/null 2>&1; then
    echo ""
    echo "*WARNING*: No SSH key loaded. Run 'ssh-add ~/.ssh/id_rsa' or manually config your SSH key in ~~/.ssh/config"
    echo "Continuing without SSH key loaded... (assuming SSH key is already configured manually)"
    echo ""
fi

# Ensure clone directory exists
mkdir -p "$CLONE_DIR" || { echo "Error: Failed to create directory $CLONE_DIR"; exit 1; }
echo "*SUCCESSFULLY validate/make dir for clone directory: $CLONE_DIR"

# logout of any existing gh auth session
echo ""
echo "Logging out of any existing GitHub CLI session..."
gh auth logout

# Login to GitHub with user that will fork/clone the repos
#   NOTE: this is NOT the same user as the <github_username> that owns the repos
#   requires PAT (Personal Access Token) with 'repo' and 'read:org' scopes
echo ""
echo "Logging in to GitHub as the user that will fork/clone the repos..."
gh auth login

# Get your GitHub username from gh auth
YOUR_USERNAME=$(gh api user --jq '.login')

# Declare array to store list of forked repos
REPOS=()

# List all public repos for the given username and fork them publicly
echo ""
echo "Forking public repos FROM $USERNAME publicly and cloning to $CLONE_DIR:"
gh repo list "$USERNAME" --visibility public --limit 100 --json name --jq '.[] | .name' | while read repo; do

  # Change to clone directory
  cd "$CLONE_DIR" || { echo "Error: Failed to change directory to $CLONE_DIR"; exit 1; }
  echo ""
  echo "*SUCCESSFULLY cd to clone dir: $CLONE_DIR"

  # fork and clone the repo
  gh repo fork "$USERNAME/$repo" --clone --remote-name origin
  echo "*SUCCESSFULLY forked & cloned repo $USERNAME/$repo as public to $YOUR_USERNAME/$repo"
  
  # Change to repo directory
  cd "$CLONE_DIR/$repo" || { echo "Failed to cd into $CLONE_DIR/$repo"; continue; }
  echo "*SUCCESSFULLY cd to repo dir: $CLONE_DIR/$repo (bound to repo: $YOUR_USERNAME/$repo)"

  # Update commit emails (NOTE: auto removes remote origin & adds remote upstream)
  git filter-repo --email-callback "return email if email != b'$OLD_EMAIL' else b'$NEW_EMAIL'" --force
  echo "*SUCCESSFULLY updated commit emails for repo $YOUR_USERNAME/$repo from $OLD_EMAIL to $NEW_EMAIL in $repo"

  # rename remote upstream to remote origin for the forked repo & set fetch URL accordingly
  #  NOTE: required to fix issue w/ filter-repo auto-changing remote origin to upstream
  #   (ie. ensures remote is set correctly in forked repo)
  git remote rename upstream origin
  git remote set-url origin "git@github.com:$YOUR_USERNAME/$repo.git"
  echo "*SUCCESSFULLY Configured origin remote for $YOUR_USERNAME/$repo"
  # Debug: Show remotes
  git remote -v
  
  # Force-push changes for '--all' branches' to the forked repo
  git push origin --all --force
  echo "*SUCCESSFULLY pushed updated commits to $YOUR_USERNAME/$repo"

  # Append repo to array
  REPOS+=("$repo")  
  echo "*SUCCESSFULLY appended repo $repo to forked/cloned REPOS array"
  echo "Current REPOS array: ${REPOS[*]}"
  echo "Current REPOS array (simple): $REPOS"
done

# gh repo list "$USERNAME" --visibility public --limit 100 --json name --jq '.[] | .name' | while read repo; do
#   if gh repo fork "$USERNAME/$repo" --clone --remote-name "origin" > /dev/null 2>&1; then
#     echo "Successfully forked & cloned repo $repo as public"
#     REPOS+=("$repo")  # Append repo to array
#     # Change to repo directory
#     cd "$CLONE_DIR/$repo" || { echo "Failed to cd into $CLONE_DIR/$repo"; continue; }
#     # Update commit emails
#     if git filter-repo --email-callback "return email if email != b'$OLD_EMAIL' else b'$NEW_EMAIL'" --force > /dev/null 2>&1; then
#       echo "Updated commit emails from $OLD_EMAIL to $NEW_EMAIL in $repo"
#       # Force-push changes to the forked repo
#       if git push origin --all --force > /dev/null 2>&1; then
#         echo "Successfully pushed updated commits to $YOUR_USERNAME/$repo"
#       else
#         echo "Failed to push updated commits to $YOUR_USERNAME/$repo"
#       fi
#     else
#       echo "Failed to update commit emails in $repo"
#     fi
#     # Return to original directory
#     cd - > /dev/null || { echo "Error: Failed to return to original directory"; exit 1; }
#   else
#     echo "Failed to fork & clone repo $repo"
#   fi
# done

# Set all forked repositories for <github_username> to private 
echo ""
echo "Setting all repos forked FROM user $USERNAME to private..."
echo "Logging out of github user $YOUR_USERNAME that repos were forked/cloned BY"
gh auth logout

echo "Logging in to github user $USERNAME"
gh auth login 

# loop through & set ALL repos to private (note: --limit 100)
echo "Setting all repos for user $USERNAME to private..."
for repo in $(gh repo list --limit 100 --json name --jq '.[].name'); do
  gh repo edit $USERNAME/$repo --visibility private --accept-visibility-change-consequences
  echo "*SUCCESSFULLY set $USERNAME/$repo to private"
done

# Set all repos forked by YOUR_USERNAME to private 
echo ""
echo "Setting all repos forked BY user $YOUR_USERNAME to private..."
echo "Logging out of github user $USERNAME that repos were forked/cloned FROM"
gh auth logout

echo "Logging in to github user $YOUR_USERNAME"
gh auth login 

# loop through & set ALL repos to private (note: --limit 100)
echo "Setting all forked repos by for user $YOUR_USERNAME to private..."
echo "Forked repos: ${REPOS[*]}"
echo "Forked repos: $REPOS"
for repo in "${REPOS[@]}"; do
  gh repo edit $YOUR_USERNAME/$repo --visibility private --accept-visibility-change-consequences
  echo "*SUCCESSFULLY set $YOUR_USERNAME/$repo to private"
done

echo ""
echo "_END EXE_"
echo ""

