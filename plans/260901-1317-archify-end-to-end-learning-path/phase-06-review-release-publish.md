---
phase: 6
title: "Review, release and publish"
status: pending
priority: P1
effort: "4h"
dependencies: [5]
---

# Phase 6: Review, Release And Publish

## Overview

Prove clean-clone reproducibility, review contracts and publish the complete branch/tag curriculum without rewriting v1 history.

## Requirements

- Functional: full tests, five diagram gates, docs/link/privacy checks, branch/tag/merge audit, GitHub push.
- Non-functional: release fail-closed; no force-push/retag; no raw local receipt; human visual inspection required.

## Related Code Files

- Create: `plans/.../reports/test-report.md`, `plans/.../reports/review-report.md`, `CHANGELOG.md`
- Modify: plan status through `ak plan`, `RELEASES.md` final map

## Implementation Steps

1. Branch `release/v2.0.0` từ fully integrated `main` hoặc dùng nó làm release audit branch without feature edits.
2. Tester subagent runs `npm run check`, clean-clone smoke, API/UI journey and diagram verification.
3. Code-reviewer checks acceptance, public contracts, regressions, security/privacy and branch evidence.
4. Human inspect all final screenshots; record pass/fail per mode.
5. Audit each feature/prompt head equals its annotated tag and each was merged with two-parent merge commit.
6. Sync plan files to completed only after evidence passes; merge release metadata, create annotated `v2.0.0`.
7. Push `main`, every feature/prompt/docs/release branch and all new tags; verify with GitHub API.

## Success Criteria

- [ ] Clean clone completes quick start without hidden local setup.
- [ ] All application and diagram gates pass on final commit.
- [ ] Review has no critical/high issue; warnings documented or fixed.
- [ ] GitHub default `main`, branches and tags match local; latest public README has no stale claim.
- [ ] v1 tags unchanged; `v2.0.0` points exactly to verified main.

## Risk Assessment

Nếu bất kỳ test, diagram, visual hoặc remote verification fail, không tạo/push `v2.0.0`; giữ branch và report blocker thay vì downgrade gate.
