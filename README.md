# TO DO
* Add an update mode to avoid checksumming new files
* Only follow paths traceable to top-level .sha256 file
* Command line switch (-w) to warn about non-checksummed files
* Check gpg signature on root .sha256 file if available, -s switch to force the check
* Signature check enforces web of trust
* Add a diff mode to show changes before saving them (may obviate need for git repo of checksum files)
