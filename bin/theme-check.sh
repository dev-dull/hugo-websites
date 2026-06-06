#!/bin/bash
#
# Pre-post theme check.
#
# Compares the pinned kayal submodule tag against the latest upstream release
# tag and, when you're behind, walks you through a *gated* bump:
#
#   1. checks the new tag out into your working tree (nothing committed yet),
#      and bumps the CI Hugo pin to whatever that theme release requires,
#   2. you eyeball it locally with bin/preview.sh -- your safety gate,
#   3. re-run this script and it commits the bump as its own isolated commit.
#
# Theme releases and Hugo versions are coupled: kayal v0.4.0, for instance,
# switched to template fields (site.Language.Locale) that only exist in newer
# Hugo, so bumping the theme without bumping Hugo breaks the build. The theme
# declares its tested Hugo range in config.toml's [module.hugoVersion] block; we
# pin our deploy Hugo to that block's `max` (the newest version the theme was
# tested against) and keep it in lockstep -- both land in the same commit, kept
# separate from any content post so a breakage is one `git revert` away.

set -euo pipefail

errcho () { echo "$@" >&2 ; }

here="$(cd "$(dirname "$0")" && pwd)"
repoRoot="$(cd "$here/.." && pwd)"

# The theme we track. Explicit for now; generalize if a second themed site appears.
themePath="devdull.lol/themes/kayal"
themeDir="$repoRoot/$themePath"

# Our deploy workflow (holds the Hugo pin) and the theme's workflow (declares the
# Hugo version it's built/tested against).
workflowRel=".github/workflows/build-and-deploy.yaml"
workflowFile="$repoRoot/$workflowRel"
themeConfigFile="$themeDir/config.toml"

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

# The newest Hugo the currently checked-out theme was tested against: the `max`
# of config.toml's [module.hugoVersion] block (read only within that section so
# a stray `max =` elsewhere can't be picked up).
theme_required_hugo () {
  awk '
    /^[[:space:]]*\[module\.hugoVersion\]/ { inSec = 1; next }
    /^[[:space:]]*\[/                      { inSec = 0 }
    inSec && /^[[:space:]]*max[[:space:]]*=/ {
      gsub(/.*=[[:space:]]*"?/, ""); gsub(/".*/, ""); print; exit
    }
  ' "$themeConfigFile" 2>/dev/null
}

# The Hugo version our deploy workflow currently pins. Reads from a file arg so it
# works against both the working tree and `git show HEAD:...` output.
hugo_pin_in () {
  grep -E "hugo-version:" "$1" 2>/dev/null \
    | head -1 | sed -E "s/.*hugo-version:[[:space:]]*'?([^']*)'?.*/\1/"
}

# Rewrite our deploy workflow's Hugo pin in place (portable; no sed -i quirks).
set_hugo_pin () {
  local newver="$1" tmp
  tmp="$(mktemp)"
  sed -E "s/(hugo-version:[[:space:]]*')[^']*(')/\1${newver}\2/" "$workflowFile" > "$tmp"
  mv "$tmp" "$workflowFile"
}

# What the repo currently records for the submodule, vs what's on disk now.
committedSha="$(git -C "$repoRoot" rev-parse "HEAD:$themePath")"
workingSha="$(git -C "$themeDir" rev-parse HEAD)"

# ---------------------------------------------------------------------------
# Case 1: a bump is already checked out but not yet committed (resumed run).
# This is where you land after previewing. Offer to commit it -- theme pointer
# plus any Hugo-pin change -- alone, in one commit.
# ---------------------------------------------------------------------------
if [ "$committedSha" != "$workingSha" ]; then
  fromTag="$(tag_of "$committedSha")"
  toTag="$(tag_of "$workingSha")"

  # Did the Hugo pin move too? Compare committed workflow vs working tree.
  hugoFrom="$(git -C "$repoRoot" show "HEAD:$workflowRel" | hugo_pin_in /dev/stdin)"
  hugoTo="$(hugo_pin_in "$workflowFile")"

  echo "A theme bump is staged in your working tree but not committed:"
  echo "    theme:  $fromTag  ->  $toTag"
  paths=("$themePath")
  msg="Bump kayal theme $fromTag -> $toTag"
  if [ "$hugoFrom" != "$hugoTo" ]; then
    echo "    Hugo:   $hugoFrom  ->  $hugoTo"
    paths+=("$workflowRel")
    msg="$msg (Hugo $hugoFrom -> $hugoTo)"
  fi
  echo
  echo "You've (hopefully) previewed it with bin/preview.sh by now."

  if gum confirm "Commit this bump as its own commit?"; then
    # Pathspec commit: records *only* these paths, even if other files happen to
    # be staged -- guarantees the bump stays isolated from any content post.
    git -C "$repoRoot" commit "${paths[@]}" -m "$msg"
    echo "Committed. Push when ready (push to main auto-deploys)."
  else
    echo "Left uncommitted. To undo the checkout instead:"
    echo "    git -C \"$themePath\" checkout $fromTag"
    [ "$hugoFrom" != "$hugoTo" ] && echo "    git checkout -- $workflowRel"
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

# Keep the CI Hugo pin in lockstep with what the new theme release requires.
reqHugo="$(theme_required_hugo)"
curHugo="$(hugo_pin_in "$workflowFile")"
if [ -z "$reqHugo" ]; then
  gum style --foreground 214 \
    "Couldn't read the theme's required Hugo version -- leaving the CI pin at $curHugo. Verify the build manually."
elif [ "$reqHugo" != "$curHugo" ]; then
  set_hugo_pin "$reqHugo"
  echo "Bumped CI Hugo pin: $curHugo -> $reqHugo (required by $latest)."
fi

echo
echo "Checked out $latest. Nothing is committed yet."
echo "Next:"
echo "    1. bin/preview.sh   # eyeball your real content on the new theme"
echo "    2. re-run bin/theme-check.sh   # it'll offer to commit theme + Hugo pin"
