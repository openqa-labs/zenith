#!/usr/bin/env bash
# Validate all skills in the skills/ directory.
# Run locally before pushing: bash scripts/validate.sh

set -euo pipefail

SKILLS_DIR="skills"
failed=0

if [ ! -d "$SKILLS_DIR" ]; then
  echo "ERROR: skills/ directory not found"
  exit 1
fi

skill_count=0

for skill_dir in "$SKILLS_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  skill_count=$((skill_count + 1))

  # Check SKILL.md exists
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "FAIL [$skill_name] missing SKILL.md"
    failed=1
    continue
  fi

  # Check required frontmatter fields
  if ! grep -q "^name:" "$skill_dir/SKILL.md"; then
    echo "FAIL [$skill_name] SKILL.md missing 'name:' frontmatter"
    failed=1
  fi

  if ! grep -q "^description:" "$skill_dir/SKILL.md"; then
    echo "FAIL [$skill_name] SKILL.md missing 'description:' frontmatter"
    failed=1
  fi

  if [ $failed -eq 0 ]; then
    echo "OK   [$skill_name]"
  fi
done

if [ "$skill_count" -eq 0 ]; then
  echo "WARNING: No skills found in $SKILLS_DIR/"
fi

if [ $failed -ne 0 ]; then
  echo ""
  echo "Validation failed. Fix the errors above before pushing."
  exit 1
fi

echo ""
echo "All $skill_count skill(s) valid."

# Sync skills/ → .claude/skills/ symlinks
CLAUDE_SKILLS_DIR=".claude/skills"
if [ -d "$CLAUDE_SKILLS_DIR" ]; then
  synced=0
  for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    target="$CLAUDE_SKILLS_DIR/$skill_name"
    if [ ! -e "$target" ]; then
      ln -s "../../$SKILLS_DIR/$skill_name" "$target"
      echo "LINK [$skill_name] symlinked into $CLAUDE_SKILLS_DIR/"
      synced=$((synced + 1))
    fi
  done
  [ $synced -eq 0 ] && echo "LINK all skills already symlinked"
fi
