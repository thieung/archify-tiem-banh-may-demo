---
phase: 3
title: "Tests, observability and evidence"
status: pending
priority: P1
effort: "1d"
dependencies: [2]
---

# Phase 3: Tests, Observability And Evidence

## Overview

Tạo bằng chứng application-owned để follower biết diagram nào được code, test và runtime trace hỗ trợ.

## Requirements

- Functional: unit lifecycle, integration API, end-to-end happy/failure journeys, scripted demo output.
- Non-functional: sequential default, temp/ephemeral state, no orphan server, fixed clock/IDs cho committed fixture.

## Related Code Files

- Create: `tests/unit/order-lifecycle.test.mjs`
- Create: `tests/integration/order-api.test.mjs`
- Create: `tests/e2e/order-journey.test.mjs`
- Create: `src/observability/event-log.mjs`, `scripts/run-demo.mjs`
- Create: `evidence/runtime/demo-run.jsonl`, `evidence/application-verification.md`

## Implementation Steps

1. Branch `feature/07-tests-observability`.
2. Thêm structured events: order created, payment result, kitchen queued/ticked, completed.
3. Viết tests ở lowest reliable layer; e2e chỉ giữ critical journey.
4. `npm run demo` tạo deterministic scenario evidence và exit sạch.
5. Thêm `npm run check` chạy syntax/type-like checks, tests và demo assertions.
6. Commit/tag `feature-07-tests-observability-v2.0.0`, merge `--no-ff`.

## Success Criteria

- [ ] Unit/integration/e2e pass tuần tự.
- [ ] Cover happy, sold-out, payment declined, invalid transition và kitchen empty queue.
- [ ] Evidence không chứa token, private path hoặc nondeterministic timestamp.
- [ ] Application verification report không dùng Archify pass thay cho test pass.

## Risk Assessment

Nếu test cần sleep hoặc random port collision, expose `createServer({port: 0})`, inject worker ticks và chờ server close thay vì retry loop.
