#!/usr/bin/env bash

# commit-msg hook: append a Signed-off-by trailer for the author.
#
# Uses `git interpret-trailers` so the signoff joins any existing footer block
# (e.g. Co-authored-by:, Co-developed-by:) without an intervening blank line,
# and so a signoff by the same author is not added twice.

SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/\1/p')

git interpret-trailers --in-place \
  --if-exists addIfDifferent \
  --trailer "Signed-off-by: $SOB" \
  "$1"

# Safety net: reject the commit if multiple Signed-off-by lines share an email.
duplicates=$(grep -i '^Signed-off-by: ' "$1" |
  grep -oE '<[^>]+>' |
  sort | uniq -d)
if [ -n "$duplicates" ]; then
  echo >&2 "Duplicate Signed-off-by lines for: $duplicates"
  exit 1
fi
