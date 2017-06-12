#!/usr/bin/env bash

# Check if the script is run in a git repository.
if [[ ! -d .git ]] && [[ ! $(git rev-parse --git-dir &> /dev/null) ]]; then

  printf "This script must be run in a git repository.\n"
  exit
else

  readonly FIRST_ARGUMENT=$1

  # If no branch name was passes use master as the default value
  readonly UPSTREAM_BRANCH=${FIRST_ARGUMENT:-master}

  echo "$UPSTREAM_BRANCH"

  readonly BRANCHES_MERGED_INTO_UPSTREAM_BRANCH="$(git checkout "$UPSTREAM_BRANCH" &> /dev/null && git branch --merged | grep -v -e '\*')"

  echo "$BRANCHES_MERGED_INTO_UPSTREAM_BRANCH"

  # Check if there are any uncommitted changes.
  if [[ ! -z "$(git status --porcelain)" ]]; then

    printf "Please resolve any uncommitted changes, before running this script.\n"
    exit
  fi

   # Delete any branches that have been merged into the upstream branch.
   printf "%s" "$BRANCHES_MERGED_INTO_UPSTREAM_BRANCH" | xargs -n 1 git branch -d

  # Prune any existing remotes, and delete and merged remotes.
  if [[ ! -z "$(git remote)" ]]; then

    git remote | xargs -n 1 git remote prune

    git ls-remote --exit-code origin &> /dev/null
    if [[ $? -eq 0 ]]; then

      # Delete any merged remote branches
      printf "%s" "$BRANCHES_MERGED_INTO_UPSTREAM_BRANCH" | xargs git push origin --delete
    else
      printf "You seem to be missing the origin remote. This script currently uses origin remote to delete remote branches.\n"
    fi
  fi
fi
