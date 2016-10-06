#!/usr/bin/env bash

# Check if the script is run in a git repository.
if [[ ! -d .git ]] && [[ ! $(git rev-parse --git-dir &> /dev/null) ]]; then

  printf "This script must be run in a git repository.\n"
  exit
else

  readonly BRANCHES_MERGED_INTO_MASTER="$(git branch --merged master | grep -v -e 'master' -e '\*')"

  # Check if there are any uncommitted changes.
  if [[ ! -z "$(git status --porcelain)" ]]; then

    printf "Please resolve any uncommitted changes, before running this script.\n"
    exit
  fi

  # To exclude the current branch in addition to master, add an argument of ecb,
  # (i.e. Exclude Current Branch) when running the script.
  if [[ "$1" != "ecb" ]]; then
    if [[ "$(git branch | grep -e '\*' | cut -d ' ' -f2 )" != "master" ]]; then

      git checkout master
    fi
  fi

  # Delete any branches that have been merged into master, optionally excluding
  # current branch.
  printf "%s" "$BRANCHES_MERGED_INTO_MASTER" | xargs -n 1 git branch -d

  # Prune any existing remotes, and delete and merged remotes.
  if [[ ! -z "$(git remote)" ]]; then

    git remote | xargs -n 1 git remote prune

    git ls-remote --exit-code origin &> /dev/null
    if [[ $? -eq 0 ]]; then

      # Delete any merged remote branches
      printf "%s" "$BRANCHES_MERGED_INTO_MASTER" | xargs git push origin --delete
    else
      printf "You seem to be missing the origin remote. This script currently uses origin remote to delete remote branches.\n"
    fi
  fi
fi
