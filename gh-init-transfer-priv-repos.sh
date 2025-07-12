#!/bin/bash

DESCR="
#==================================#
Usage: $0 <github-username> <target_github-username>
Requirements: gh CLI
Requirements: gh auth login for <github-username> organization (step #5 above|below)
This script initilizes a transfer all PRIVATE repositories in the <github-username> organization
It shows the visibility of each initialized PRIVATAE repository transfer
The <target_github-username> for transfer needs to manually accept the transfer on GitHub.com within 24 hours
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
 ✓ Logged in as <github-username>
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

# Check if both username and target username are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <target_username>"
    exit 1
fi

USERNAME="$1"
TARGET_USER="$2"

# Create a temporary file to track transferred repos
TRANSFERRED_REPOS=$(mktemp)

# List only private repos and initialize transfer for each
gh repo list "$USERNAME" --visibility private --limit 100 --json name,visibility --jq '.[] | .name' | while read repo; do
  visibility=$(gh repo view "$USERNAME/$repo" --json visibility --jq '.visibility')
  if gh api -X POST \
    -H "Accept: application/vnd.github+json" \
    /repos/"$USERNAME/$repo"/transfer \
    -f new_owner="$TARGET_USER" > /dev/null 2>&1; then
    echo "$repo $visibility" >> "$TRANSFERRED_REPOS"
    echo "Initialized transfer for $repo to $TARGET_USER"
  else
    echo "Failed to initialize transfer for $repo"
  fi
done

# List private repos with transfer requests initialized
echo "Private repos with transfer requests initialized for $TARGET_USER:"
cat "$TRANSFERRED_REPOS"

# Clean up temporary file
rm "$TRANSFERRED_REPOS"

echo ""
echo "_END EXE_"
echo ""
