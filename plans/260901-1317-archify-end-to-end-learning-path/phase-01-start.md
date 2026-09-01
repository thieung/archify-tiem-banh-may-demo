---
phase: 1
title: "Learning baseline and repository layout"
status: pending
priority: P1
effort: "3h"
dependencies: []
---

# Phase 1: Learning Baseline And Repository Layout

## Overview

Đổi repo từ artifact-only thành curriculum có hai lớp rõ ràng: `PROPOSED` cũ để tham khảo và app/code-first `CURRENT` mới để học.

## Requirements

- Functional: bảo toàn toàn bộ v1 artifacts và Git history; tạo layout cho app, prompts, evidence, diagrams, docs, tests.
- Non-functional: không làm URL/tag v1 mất hiệu lực; không commit local path hoặc raw visual receipt.

## Architecture

```text
app source → tests/runtime evidence → prompts → diagrams/current → guide
existing sources/rendered → diagrams/proposed
```

## Related Code Files

- Move: `sources/`, `rendered/` → `diagrams/proposed/{sources,rendered}/`
- Create: `src/`, `public/`, `tests/`, `prompts/`, `evidence/`, `diagrams/current/`, `docs/`, `scripts/`
- Modify: `.gitignore`, `verify-demo.sh`, `RELEASES.md`

## Implementation Steps

1. Branch `feature/01-learning-baseline` từ `main`.
2. Di chuyển artifacts bằng Git-aware move và sửa đường dẫn verification.
3. Thêm `docs/evidence-boundaries.md`: CURRENT/OBSERVED/PROPOSED/UNKNOWN và app-vs-diagram verification.
4. Chạy v1 diagram validation tại path mới.
5. Commit, tạo annotated tag `feature-01-learning-baseline-v2.0.0`, merge `--no-ff`.

## Success Criteria

- [ ] V1 artifacts giữ nguyên hashes sau move.
- [ ] `verify-demo.sh` tìm đúng proposed artifacts và pass.
- [ ] Layout mới không có file placeholder rỗng ngoài `.gitkeep` cần thiết.

## Risk Assessment

Nếu hash thay đổi, dừng merge và dùng `git diff --summary`/SHA-256 để phân biệt move với edit; không regenerate proposed artifacts.
