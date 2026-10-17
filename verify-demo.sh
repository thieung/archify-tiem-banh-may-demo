#!/usr/bin/env bash

set -euo pipefail

DEMO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# Năm sơ đồ đầu được author cho Archify 2.16; năm sơ đồ sau cần Archify 3.1 trở lên.
ARCHIFY_ROOT="${ARCHIFY_SKILL_ROOT:-$HOME/.agents/skills/archify}"
ARCHIFY_CLI="$ARCHIFY_ROOT/bin/archify.mjs"
ARCHIFY_V3_ROOT="${ARCHIFY_V3_SKILL_ROOT:-$ARCHIFY_ROOT}"
ARCHIFY_V3_CLI="$ARCHIFY_V3_ROOT/bin/archify.mjs"

for cli in "$ARCHIFY_CLI" "$ARCHIFY_V3_CLI"; do
  if [[ ! -f "$cli" ]]; then
    echo "Không tìm thấy Archify CLI tại: $cli" >&2
    echo "Hãy cài skill hoặc truyền ARCHIFY_SKILL_ROOT / ARCHIFY_V3_SKILL_ROOT." >&2
    exit 1
  fi
done

v3_version="$(node -p 'require(process.argv[1]).version' "$ARCHIFY_V3_ROOT/package.json")"
if [[ "${v3_version%%.*}" -lt 3 ]] || [[ "${v3_version%%.*}" -eq 3 && "$(echo "$v3_version" | cut -d. -f2)" -lt 1 ]]; then
  echo "ERD, Class, Tree, Timeline và Waterfall cần Archify >= 3.1.0; đang có $v3_version tại $ARCHIFY_V3_ROOT." >&2
  echo "Truyền ARCHIFY_V3_SKILL_ROOT trỏ tới bản 3.1.0 trở lên." >&2
  exit 1
fi

node "$ARCHIFY_CLI" doctor

for mode in architecture workflow sequence dataflow lifecycle; do
  node "$ARCHIFY_CLI" validate \
    "$mode" \
    "$DEMO_ROOT/sources/tiem-banh-may.$mode.json" \
    --quality showcase \
    --json >/dev/null
  echo "[pass] $mode: showcase validation"
done

for mode in erd class tree timeline waterfall; do
  node "$ARCHIFY_V3_CLI" validate \
    "$mode" \
    "$DEMO_ROOT/sources/tiem-banh-may.$mode.json" \
    --quality showcase \
    --json >/dev/null
  echo "[pass] $mode: showcase validation (Archify $v3_version)"
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
