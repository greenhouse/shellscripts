#!/bin/bash

DESCR="
#==================================#
Usage: $0 <github-username>
Requirements: gh CLI
Requirements: gh auth login for github user that is forking/cloning (step #5 above|below)
IMPORTANT: <github_username> is NOT the gh auth login user, it is the username that owns the repos to fork/clone
This script forks ALL (public) repositories in the <github-username> organization
Everything is forked privately
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

# Check if GitHub username is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <github_username>"
    exit 1
fi

USERNAME="$1"

# Ensure gh is authenticated
if ! gh auth status > /dev/null 2>&1; then
    echo "*** ERROR: Please authenticate with GitHub CLI using 'gh auth login'"
    exit 1
fi

# Get your GitHub username from gh auth
YOUR_USERNAME=$(gh api user --jq '.login')

# List all public repos for the given username and fork them privately
echo "* Forking public repos from $USERNAME"
gh repo list "$USERNAME" --visibility public --limit 100 --json name --jq '.[] | .name' | while read repo; do
  if gh repo fork "$USERNAME/$repo" --remote-name origin > /dev/null 2>&1; then
    echo "* SUCCESSFULLY forked $USERNAME/$repo as public to $YOUR_USERNAME/$repo"
  else
    echo "** FAILED to fork $USERNAME/$repo"
  fi
done

echo ""
echo "_END EXE_"
echo ""
