#!/bin/bash
#
# Pre-post theme check.
#
# Compares the pinned kayal submodule tag against the latest upstream release
# tag and, when you're behind, walks you through a *gated* bump:
#
#   1. checks the new tag out into your working tree (nothing committed yet),
#   2. you eyeball it locally with bin/preview.sh -- your safety gate,
#   3. re-run this script and it commits the bump as its own isolated commit.
#
# The two-step (check out now, commit later) is deliberate: it forces the
# preview to happen between "new theme on disk" and "new theme in history", and
# it keeps the bump in a commit by itself so a future breakage is one `git
# revert` away and never tangled up with a content post.

set -euo pipefail

errcho () { echo "$@" >&2 ; }

here="$(cd "$(dirname "$0")" && pwd)"
repoRoot="$(cd "$here/.." && pwd)"

# The theme we track. Explicit for now; generalize if a second themed site appears.
themePath="devdull.lol/themes/kayal"
themeDir="$repoRoot/$themePath"

if [ ! -e "$themeDir/.git" ]; then
  errcho "Theme submodule not initialised at $themePath."
  errcho "Run: git submodule update --init --recursive"
  exit 1
fi

# tag_of <sha> -> the exact tag at that commit, or the raw sha if untagged.
tag_of () {
  git -C "$themeDir" describe --tags --exact-match "$1" 2>/dev/null || echo "$1"
}

# ver_gt <a> <b> -> success if version a is strictly greater than b (semver-ish).
ver_gt () {
  [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ]
}

# What the repo currently records for the submodule, vs what's on disk now.
committedSha="$(git -C "$repoRoot" rev-parse "HEAD:$themePath")"
workingSha="$(git -C "$themeDir" rev-parse HEAD)"

# ---------------------------------------------------------------------------
# Case 1: a bump is already checked out but not yet committed (resumed run).
# This is where you land after previewing. Offer to commit it, alone.
# ---------------------------------------------------------------------------
if [ "$committedSha" != "$workingSha" ]; then
  fromTag="$(tag_of "$committedSha")"
  toTag="$(tag_of "$workingSha")"

  echo "A theme bump is staged in your working tree but not committed:"
  echo "    $fromTag  ->  $toTag"
  echo
  echo "You've (hopefully) previewed it with bin/preview.sh by now."

  if gum confirm "Commit this bump as its own commit?"; then
    # Pathspec commit: records *only* the submodule pointer, even if other
    # files happen to be staged -- guarantees the bump stays isolated.
    git -C "$repoRoot" commit "$themePath" \
      -m "Bump kayal theme $fromTag -> $toTag"
    echo "Committed. Push when ready (push to main auto-deploys)."
  else
    echo "Left uncommitted. To undo the checkout instead:"
    echo "    git -C \"$themePath\" checkout $fromTag"
  fi
  exit 0
fi

# ---------------------------------------------------------------------------
# Case 2: clean state -- compare pinned tag against latest upstream release.
# ---------------------------------------------------------------------------
current="$(tag_of "$workingSha")"
remoteUrl="$(git -C "$themeDir" config --get remote.origin.url)"

echo "Checking $remoteUrl for newer releases..."
latest="$(git ls-remote --tags --refs "$remoteUrl" \
  | awk -F/ '{ print $NF }' \
  | grep -E '^v[0-9]+\.[0-9]+(\.[0-9]+)?$' \
  | sort -V \
  | tail -1)"

if [ -z "$latest" ]; then
  errcho "Could not read any release tags from upstream."
  exit 1
fi

echo "    pinned: $current"
echo "    latest: $latest"
echo

if [ "$current" = "$latest" ]; then
  echo "Up to date. :)"
  exit 0
fi

if ! ver_gt "$latest" "$current"; then
  echo "Pinned tag is newer than upstream's latest -- nothing to do."
  exit 0
fi

# Pre-1.0 caution: with kayal at 0.x, a *minor* bump can still break things.
cmaj="$(echo "${current#v}" | cut -d. -f1)"; cmin="$(echo "${current#v}" | cut -d. -f2)"
lmaj="$(echo "${latest#v}"  | cut -d. -f1)"; lmin="$(echo "${latest#v}"  | cut -d. -f2)"
if [ "$lmaj" != "$cmaj" ] || { [ "$lmaj" = 0 ] && [ "$lmin" != "$cmin" ]; }; then
  gum style --foreground 214 \
    "Heads up: this crosses a major/minor boundary on a pre-1.0 theme -- preview carefully."
fi

if ! gum confirm "Check out $latest into the working tree?"; then
  echo "Left at $current."
  exit 0
fi

git -C "$themeDir" fetch --tags --quiet origin
git -C "$themeDir" checkout --quiet "$latest"

echo
echo "Checked out $latest. Nothing is committed yet."
echo "Next:"
echo "    1. bin/preview.sh   # eyeball your real content on the new theme"
echo "    2. re-run bin/theme-check.sh   # it'll offer to commit the bump"
