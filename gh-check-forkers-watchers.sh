#!/bin/bash

DESCR="
#==================================#
Usage: $0 <github-username>
Requirements: gh CLI, jq, curl
Requirements: gh auth login for <github-username> organization (step #5 above|below)
This script lists all repositories in the <github-username> organization, including those forked by others.
It shows the visibility of each repository and who has forked them.
It also lists all repositories with their visibility and who is watching them.
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

## 2) update/add-to ~/.ssh/config
host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/<file-name>

## 3) add key generated public key to GitHub.com account (from <file-name>.pub)
# ref: https://github.com/settings/keys
#  note: select key type: 'authentication key'

## 4) install GitHub cli
$ brew install gh
$ gh --version

## 4b) install jq
$ brew install jq
$ jq --version

## 4c) install curl
$ brew install curl
$ curl --version

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

# Check if username is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <github-username>"
    echo "exit 1"
    echo ""
    exit 1
fi

USERNAME="$1"

echo ""
echo "_START EXE_"
echo ""
# List repos with forkCount > 0, their visibility, and who forked them
echo "$USERNAME Repos forked by others with visibility and forkers:"
gh repo list --limit 100 --json name,visibility,forkCount --jq '.[] | select(.forkCount > 0) | .name' | while read repo; do
  visibility=$(gh repo view $USERNAME/$repo --json visibility --jq '.visibility')
  forkers=$(curl -s -H "Authorization: Bearer $(gh auth token)" -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/$USERNAME/$repo/forks | jq -r '[.[].owner.login] | join(" ")')
  echo "$repo $visibility \"$forkers\""
done

echo ""
echo ""
# List all repos with visibility and who is watching them
echo "$USERNAME Repos with visibility and watchers:"
gh repo list --limit 100 --json name,visibility --jq '.[] | .name' | while read repo; do
  visibility=$(gh repo view $USERNAME/$repo --json visibility --jq '.visibility')
  watchers=$(curl -s -H "Authorization: Bearer $(gh auth token)" -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/$USERNAME/$repo/subscribers | jq -r '[.[].login] | join(" ")')
  echo "$repo $visibility \"$watchers\""
done

echo ""
echo "_END EXE_"
echo ""
