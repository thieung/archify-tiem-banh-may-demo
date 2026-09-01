---
title: "Archify end-to-end learning path"
description: "Biến demo artifact thành app chạy thật, prompt có evidence và curriculum Git tái tạo được."
status: pending
priority: P1
effort: "3-5 ngày"
branch: plan/end-to-end-learning-path
tags: [archify, nodejs, tutorial, evidence, git-curriculum]
created: 2026-09-01
---

# Archify End-to-End Learning Path

## Overview

Repo hiện chỉ chứng minh Archify render và validate diagram. Kế hoạch này thêm một app Tiệm bánh Mây tối giản nhưng chạy thật, tests và runtime evidence, rồi dùng năm prompt riêng để AI Agent đọc source và tạo năm diagram `CURRENT`. Mỗi feature, prompt và guide đi qua branch → annotated tag → `--no-ff` merge về `main`.

## Brainstorm Contract

- Outcome: follower checkout từng tag, chạy app, quan sát flow, dán prompt, rồi đối chiếu diagram với code/test/log.
- Constraints: Node.js `>=20`; không dependency runtime; frontend vanilla; `node:test`; app mặc định port `3000`, tests dùng port `0`; nội dung tiếng Việt; KISS; diagram validation và application verification báo riêng.
- Non-goals: production auth, database thật, payment thật, cloud deployment, benchmark hoặc load test.
- Public contracts: HTTP API, order states/events, prompt text, evidence map, branch/tag curriculum và `npm` commands.

## Goals

| # | Goal | Priority |
|---|---|---|
| 1 | App checkout chạy thật với happy path, hết hàng, payment declined và kitchen progression | P1 |
| 2 | Tests/log deterministic chứng minh behavior thuộc app | P1 |
| 3 | Năm prompt code-first tạo năm diagram `CURRENT` có source evidence | P1 |
| 4 | Guide non-tech đi theo branch/tag, không cần đoán bước | P1 |
| 5 | Release `v2.0.0` chỉ sau app, diagram, visual và Git gates | P1 |

## Phases

| # | Phase | Status | Depends on |
|---|---|---|---|
| 1 | [Learning baseline and repository layout](./phase-01-start.md) | Pending | — |
| 2 | [Runnable app features](./phase-02-runnable-app-features.md) | Pending | 1 |
| 3 | [Tests, observability and evidence](./phase-03-tests-observability-evidence.md) | Pending | 2 |
| 4 | [Prompts and CURRENT diagrams](./phase-04-prompts-current-diagrams.md) | Pending | 3 |
| 5 | [Follower guide and Git curriculum](./phase-05-follower-guide-curriculum.md) | Pending | 4 |
| 6 | [Review, release and publish](./phase-06-review-release-publish.md) | Pending | 5 |

## Branch And Tag Contract

- Mỗi branch bắt đầu từ `main` mới nhất, chỉ sở hữu một learning slice.
- Trước merge: focused tests/Archify gate pass, commit, annotated part tag trên feature head.
- Merge: `git merge --no-ff`; giữ branch remote để follower checkout.
- App branches: `feature/01-*` tới `feature/07-*`.
- Prompt branches: `prompt/01-*` tới `prompt/05-*`.
- Docs branch: `docs/01-follower-guide`; release branch: `release/v2.0.0`.
- Không retag hoặc force-push các tag `v1.x`; final integration tag mới là `v2.0.0`.

| Order | Branch | Annotated tag | Owned slice | Pre-tag gate |
|---:|---|---|---|---|
| 1 | `feature/01-learning-baseline` | `feature-01-learning-baseline-v2.0.0` | Move proposed artifacts, evidence boundary, layout | Proposed hashes + `verify-demo.sh` |
| 2 | `feature/02-app-foundation` | `feature-02-app-foundation-v2.0.0` | Package scripts, server, health/static | Health smoke + syntax check |
| 3 | `feature/03-order-domain` | `feature-03-order-domain-v2.0.0` | Catalog/order stores, guarded states | Domain unit tests |
| 4 | `feature/04-payment-mock` | `feature-04-payment-mock-v2.0.0` | Approved/declined payment contract | Payment unit/integration tests |
| 5 | `feature/05-kitchen-worker` | `feature-05-kitchen-worker-v2.0.0` | Queue and deterministic ticks | Queue/state tests |
| 6 | `feature/06-web-checkout` | `feature-06-web-checkout-v2.0.0` | Browser checkout/status UI | API/UI smoke |
| 7 | `feature/07-tests-observability` | `feature-07-tests-observability-v2.0.0` | Unit/integration/e2e, events, demo fixture | `npm run check` |
| 8 | `prompt/01-architecture-current` | `prompt-01-architecture-current-v2.0.0` | Prompt, evidence, Architecture output | Source-truth + render + visual |
| 9 | `prompt/02-workflow-current` | `prompt-02-workflow-current-v2.0.0` | Prompt, evidence, Workflow output | Source-truth + render + visual |
| 10 | `prompt/03-sequence-current` | `prompt-03-sequence-current-v2.0.0` | Prompt, evidence, Sequence output | Source-truth + render + visual |
| 11 | `prompt/04-dataflow-current` | `prompt-04-dataflow-current-v2.0.0` | Prompt, evidence, Data Flow output | Source-truth + render + visual |
| 12 | `prompt/05-lifecycle-current` | `prompt-05-lifecycle-current-v2.0.0` | Prompt, evidence, Lifecycle output | Source-truth + render + visual |
| 13 | `docs/01-follower-guide` | `docs-01-follower-guide-v2.0.0` | README, labs, Git curriculum, troubleshooting | Links + privacy + clean-clone dry run |
| 14 | `release/v2.0.0` | `release-v2.0.0-rc.1` | Final evidence and release audit only | Full app + diagrams + review |

## Runtime Contract

- `package.json.engines.node`: `>=20`; no production dependencies and no install-generated application code.
- `npm start`: persistent app at `http://localhost:3000`, overridable with `PORT`.
- `npm test`: `node --test --test-concurrency=1`; integration/e2e bind ephemeral port `0` and close it.
- `npm run demo`: constructs fresh in-memory stores with fixed clock/ID, prints deterministic scenario evidence, then exits.
- `npm run check`: syntax checks, tests, demo assertion and diagram verification script.
- Restart resets catalog/orders/queue by design; README and UI must say this explicitly.
- Clean-clone gate: `git clone <repo> && cd archify-tiem-banh-may-demo && npm test && npm run demo && npm run check`.

## Evidence Gates

1. **Application behavior gate:** unit/integration/e2e and deterministic runtime event output prove app-owned behavior.
2. **Source-truth gate:** every diagram node, edge, message, datum, state and event maps to an exact source/test/evidence path; unsupported facts are removed or marked `UNKNOWN`/`PROPOSED`.
3. **Archify render gate:** typed JSON passes 9/9 showcase with 0 composition errors/warnings, atomic delivery succeeds, containment/captures pass.
4. **Human visual gate:** a person inspects required light/dark screenshots; raw receipt remains `visualReview: pending`.

## Success Criteria

- [ ] Node `>=20`; `npm start`, `npm run demo`, `npm test`, `npm run check` chạy từ clean clone theo Runtime Contract.
- [ ] API và UI tạo/đọc đơn; hết hàng và payment declined có output kiểm tra được; kitchen tick chuyển trạng thái hợp lệ.
- [ ] Unit, integration và end-to-end tests pass tuần tự, không orphan process.
- [ ] Runtime evidence deterministic và không chứa secret/private path.
- [ ] Năm prompt, evidence maps, typed JSON, standalone HTML và screenshots tồn tại.
- [ ] Mỗi diagram pass riêng source-truth gate và Archify render gate; visual receipts pass và human review được ghi riêng.
- [ ] README/tutorial giải thích code-first và design-first, exact commands, expected output, failure modes và branch/tag learning order.
- [ ] Code review không có critical/high; `main` sạch, đồng bộ remote; mọi requested branch/tag đã push.

## Risks

- Diagram có thể drift khỏi code: mỗi prompt branch bắt buộc chứa evidence map và chạy tests trước Archify.
- Async flow dễ flaky: kitchen dùng explicit deterministic ticks, không dựa vào sleep.
- In-memory store dễ bị hiểu là production: UI/docs/diagram phải ghi rõ demo-only, restart sẽ reset dữ liệu.
- Generated receipts có local path: raw receipts ignored; commit public evidence summary + screenshots/hash.

## Câu Hỏi Chưa Rõ

- Không có quyết định blocking. Node.js dependency-free và in-memory deterministic là assumptions đã ghi rõ, có thể đổi trước khi approve plan.

<!-- slug: archify-end-to-end-learning-path -->
