---
title: Plan Archify end-to-end learning path
date: 2026-09-01
summary: "Chốt curriculum app chạy thật, source-truth gates và 14 branch/tag slices cho release v2.0.0."
---

# Plan Archify end-to-end learning path

## What happened

Scout xác nhận repo hiện chỉ có proposed diagram artifacts. Plan mới chia sáu phase: learning baseline, app Node.js chạy thật, application evidence, năm prompt/diagram CURRENT, follower guide và release audit.

## Decision

Dùng Node.js >=20 không runtime dependency, frontend vanilla, node:test tuần tự, in-memory deterministic stores và explicit kitchen ticks. Tách application behavior gate, source-truth gate, Archify render gate và human visual gate. Mỗi feature/prompt/docs slice có branch, annotated tag và --no-ff merge riêng.

## Next steps

Đưa plan branch cho người dùng review. Chỉ bắt đầu feature/01 sau khi plan được approve; v2.0.0 chỉ push khi clean-clone, app tests, năm diagram và remote audit đều pass.

> Historical work record — not durable authority. Prefer docs/specs/ADRs for current decisions.
