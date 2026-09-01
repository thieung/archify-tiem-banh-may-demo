---
phase: 5
title: "Follower guide and Git curriculum"
status: pending
priority: P1
effort: "5h"
dependencies: [4]
---

# Phase 5: Follower Guide And Git Curriculum

## Overview

Viết lại onboarding theo mô hình việc đời thường → chạy app → xem evidence → dán prompt → đọc diagram → tự kiểm tra.

## Requirements

- Functional: prerequisites, quick start, exact expected output, five labs, design-first extension, troubleshooting, branch/tag map.
- Non-functional: non-tech friendly; không hype; không dùng private provenance; public links repo-relative.

## Related Code Files

- Modify: `README.md`, `RELEASES.md`
- Create: `docs/tutorial.md`, `docs/git-learning-path.md`, `docs/design-first-vs-code-first.md`, `docs/troubleshooting.md`

## Implementation Steps

1. Branch `docs/01-follower-guide`.
2. README: 10-minute quick start và “repo này học gì”.
3. Tutorial: năm lab, mỗi lab có chuẩn bị, prompt, expected/negative result, evidence và self-check.
4. Git guide: checkout branch/tag theo thứ tự, diff trước/sau, không cần merge khi chỉ học.
5. Design-first extension: proposed → implement → current → delta; ghi rõ không chạy app bằng diagram validator.
6. Link-check, privacy scan, clean-clone dry run; tag `docs-01-follower-guide-v2.0.0`, merge `--no-ff`.

## Success Criteria

- [ ] Follower mới phân biệt được AI job, Archify job và app test job.
- [ ] Mọi command chạy từ repo root; mọi link tồn tại.
- [ ] Không còn wording “sẽ thêm sau”, placeholder URL hoặc local absolute path.
- [ ] Branch/tag table khớp Git refs thật.

## Risk Assessment

Nếu guide dài quá, README giữ quick path và routing; chi tiết nằm trong `docs/tutorial.md`, không lặp toàn bộ nội dung ở hai nơi.
