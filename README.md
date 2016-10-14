# Clean Repository
If you'd like to automatically clean a local/remote repository of the branches that have already been merged into master, do the following.

* Make clean-branches.sh executable.
  * `chmod +x /path/to/clean-branches.sh`
* Run the script.
  * `/path/to/clean-branches.sh`

Assuming the current branch has been merged into master, and you want to exclude it from being removed, in addition to the master branch, pass the following argument.

```
/path/to/clean-branches.sh ecb
```
