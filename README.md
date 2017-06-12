# Clean Repository
If you'd like to automatically clean a local/remote repository of the branches that have already been merged into your upstream branch, do the following.

* Make clean-branches.sh executable.
  * `chmod +x /path/to/clean-branches.sh`
* Run the script.
  * `/path/to/clean-branches.sh`
    * The upstream branch defaults to master but you can pass a different branch as the first argument.
        * Example: `/path/to/clean-branches.sh name-of-upstream-branch`

