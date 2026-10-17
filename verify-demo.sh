#!/usr/bin/env bash

set -euo pipefail

DEMO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ARCHIFY_ROOT="${ARCHIFY_SKILL_ROOT:-$HOME/.agents/skills/archify}"
ARCHIFY_CLI="$ARCHIFY_ROOT/bin/archify.mjs"

if [[ ! -f "$ARCHIFY_CLI" ]]; then
  echo "Không tìm thấy Archify CLI tại: $ARCHIFY_CLI" >&2
  echo "Hãy cài skill hoặc truyền ARCHIFY_SKILL_ROOT." >&2
  exit 1
fi

# Các JSON dùng schema của Archify 3.1 (ERD, Class, Tree, Timeline, Waterfall và lifecycle schema 3).
archify_version="$(node -p 'require(process.argv[1]).version' "$ARCHIFY_ROOT/package.json")"
IFS=. read -r major minor _ <<< "$archify_version"
if (( major < 3 || (major == 3 && minor < 1) )); then
  echo "Demo cần Archify >= 3.1.0; đang có $archify_version tại $ARCHIFY_ROOT." >&2
  echo "Cập nhật skill hoặc truyền ARCHIFY_SKILL_ROOT trỏ tới bản mới." >&2
  exit 1
fi

node "$ARCHIFY_CLI" doctor

for mode in architecture workflow sequence dataflow lifecycle erd class tree timeline waterfall; do
  node "$ARCHIFY_CLI" validate \
    "$mode" \
    "$DEMO_ROOT/sources/tiem-banh-may.$mode.json" \
    --quality showcase \
    --json >/dev/null
  echo "[pass] $mode: showcase validation"
done

found_receipt=false
for receipt in "$DEMO_ROOT"/rendered/*.visual-check.json; do
  [[ -e "$receipt" ]] || continue
  found_receipt=true
  node -e '
    const fs = require("node:fs");
    const path = process.argv[1];
    const receipt = JSON.parse(fs.readFileSync(path, "utf8"));
    if (!receipt.ok || receipt.containment?.status !== "pass" || receipt.captures?.status !== "pass") {
      console.error(`[fail] visual receipt: ${path}`);
      process.exit(1);
    }
    console.log(`[pass] visual receipt: ${path.split("/").pop()} (${receipt.visualReview})`);
  ' "$receipt"
done

if [[ "$found_receipt" == false ]]; then
  echo "[info] Không có raw visual receipt; chạy visual-check local để tạo lại."
fi

echo "Demo verification hoàn tất. Human visual review vẫn là gate riêng."
