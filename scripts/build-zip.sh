#!/usr/bin/env bash
# Builds a zip for uploading as a custom skill in the Claude app.
#
#   ./scripts/build-zip.sh                 -> dist/restaurant-picker.zip (no personal profile)
#   ./scripts/build-zip.sh --with-profile  -> also includes skills/restaurant-picker/taste-profile.md
#   ./scripts/build-zip.sh --name NAME     -> renames the skill (folder and frontmatter), e.g. to
#                                             test alongside an existing skill with the same name
#
# Never publish a zip built with --with-profile: it contains your personal data.
set -euo pipefail
cd "$(dirname "$0")/.."

NAME="restaurant-picker"
WITH_PROFILE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-profile) WITH_PROFILE=1; shift ;;
    --name) NAME="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -R skills/restaurant-picker "$TMP/$NAME"
if [[ $WITH_PROFILE -eq 0 ]]; then
  rm -f "$TMP/$NAME/taste-profile.md"
elif [[ ! -f "$TMP/$NAME/taste-profile.md" ]]; then
  echo "No skills/restaurant-picker/taste-profile.md found" >&2; exit 1
fi
if [[ "$NAME" != "restaurant-picker" ]]; then
  sed -i.bak -e "s/^name: restaurant-picker$/name: $NAME/" \
             -e 's/^description: "/description: "[TEST BUILD] /' "$TMP/$NAME/SKILL.md" && rm "$TMP/$NAME/SKILL.md.bak"
fi
find "$TMP" -name '.DS_Store' -delete

mkdir -p dist
OUT="$PWD/dist/$NAME.zip"
rm -f "$OUT"
(cd "$TMP" && zip -qr "$OUT" "$NAME")
echo "Built dist/$NAME.zip"
