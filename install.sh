#!/usr/bin/env bash
# Deploys the Claude agent scaffold into a target project directory.
#
# Usage:
#   ./install.sh <NewProjectDir> [--pack <pack>[@<version>]] [--force]
#
# Arguments:
#   NewProjectDir   Absolute or relative path to the target project directory.
#                   Created if it does not exist.
#
# Options:
#   --pack <ref>    Pack and optional version. Default: csharp@latest.
#                   Examples: --pack csharp, --pack appsheet@v1, --pack python@v2.
#   --force         Overwrite existing files. Without this, existing files are
#                   skipped and reported.

set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") <NewProjectDir> [--pack <pack>[@<version>]] [--force]

Deploys the Claude agent scaffold into <NewProjectDir>.

Options:
  --pack <ref>  Pack and optional version (default: csharp). e.g. appsheet@v1
  --force       Overwrite existing files in the target.
  -h, --help    Show this help and exit.
EOF
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

new_project_dir="$1"
shift
force=0
pack_ref="csharp"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force) force=1 ;;
    --pack)
      shift
      if [ "$#" -lt 1 ]; then
        echo "--pack requires an argument" >&2; exit 1
      fi
      pack_ref="$1"
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

# Parse pack@version. Default version is 'latest' which resolves to the highest
# numeric v<N> directory present under packs/<pack>/.
if [[ "$pack_ref" == *"@"* ]]; then
  pack_name="${pack_ref%@*}"
  pack_version="${pack_ref#*@}"
else
  pack_name="$pack_ref"
  pack_version="latest"
fi

script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source_root="$script_path"
common_root="$source_root/common"
pack_dir="$source_root/packs/$pack_name"

if [ ! -d "$common_root" ]; then
  echo "Source layout not found. Expected common/ at $source_root" >&2
  exit 1
fi

if [ ! -d "$pack_dir" ]; then
  echo "Unknown pack: $pack_name. Available:" >&2
  ls "$source_root/packs" 2>/dev/null | grep -v '^README\|^SHARED\|\.md$' >&2 || true
  exit 1
fi

# Resolve version.
if [ "$pack_version" = "latest" ]; then
  pack_version="$(ls -1 "$pack_dir" 2>/dev/null | grep -E '^v[0-9]+$' | sort -V | tail -1 || true)"
  if [ -z "$pack_version" ]; then
    echo "Pack '$pack_name' has no installable versions yet. See packs/$pack_name/PACK.md" >&2
    exit 1
  fi
fi

pack_version_dir="$pack_dir/$pack_version"
if [ ! -d "$pack_version_dir" ]; then
  echo "Unknown version '$pack_version' for pack '$pack_name'. Available:" >&2
  ls -1 "$pack_dir" 2>/dev/null | grep -E '^v[0-9]+$' >&2 || true
  exit 1
fi

claude_template_rel="do-work/templates/CLAUDE.md.template"
if [ ! -f "$pack_version_dir/$claude_template_rel" ]; then
  echo "Pack '$pack_name@$pack_version' is missing required $claude_template_rel" >&2
  exit 1
fi

if [ ! -d "$new_project_dir" ]; then
  echo "Creating target directory: $new_project_dir"
  mkdir -p "$new_project_dir"
fi

target="$(cd -- "$new_project_dir" >/dev/null 2>&1 && pwd)"

echo "Source: $source_root"
echo "Pack:   $pack_name@$pack_version"
echo "Target: $target"
echo

copied=0
skipped=0
copied_list=()
skipped_list=()

# copy_tree <source_root> - walks a source tree and copies files into the
# target, preserving relative paths. The CLAUDE.md.template special-case is
# skipped here; handled after both trees are copied.
copy_tree() {
  local src="$1"
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"

    # Skip the special-cased template - it installs to <target>/CLAUDE.md below.
    if [ "$rel" = "$claude_template_rel" ]; then
      continue
    fi

    local dest="$target/$rel"
    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] && [ "$force" -eq 0 ]; then
      skipped=$((skipped + 1))
      skipped_list+=("$rel")
      continue
    fi

    cp "$file" "$dest"
    copied=$((copied + 1))
    copied_list+=("$rel")
  done < <(find "$src" -type f -print0)
}

# Common files first, then the pack overlay wins on any collision.
copy_tree "$common_root"
copy_tree "$pack_version_dir"

# Special-case: install CLAUDE.md.template from the chosen pack to <target>/CLAUDE.md.
claude_dest="$target/CLAUDE.md"
if [ -e "$claude_dest" ] && [ "$force" -eq 0 ]; then
  skipped=$((skipped + 1))
  skipped_list+=("CLAUDE.md")
else
  cp "$pack_version_dir/$claude_template_rel" "$claude_dest"
  copied=$((copied + 1))
  copied_list+=("CLAUDE.md")
fi

# Write pack identity sentinel (always, overwriting) so future tooling can
# detect the pack+version the target was bootstrapped from.
pack_sentinel="$target/.claude/.pack"
mkdir -p "$(dirname "$pack_sentinel")"
scaffold_commit="$(git -C "$source_root" rev-parse --short HEAD 2>/dev/null || echo unknown)"
cat > "$pack_sentinel" <<EOF
pack: $pack_name
version: $pack_version
installed_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
scaffold_commit: $scaffold_commit
EOF

echo "Copied $copied file(s):"
for f in "${copied_list[@]}"; do
  echo "  + $f"
done

if [ "$skipped" -gt 0 ]; then
  echo
  echo "Skipped $skipped existing file(s) - re-run with --force to overwrite:"
  for f in "${skipped_list[@]}"; do
    echo "  - $f"
  done
fi

echo
echo "Pack identity written to .claude/.pack"
echo
echo "Done. Next steps:"
echo "  1. cd $target"
echo "  2. Review CLAUDE.md and .claude/conventions/"
echo "  3. git add . && git commit -m 'chore: bootstrap claude agent scaffold'"
