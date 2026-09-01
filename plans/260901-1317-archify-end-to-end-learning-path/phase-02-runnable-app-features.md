---
phase: 2
title: "Runnable app features"
status: pending
priority: P1
effort: "1.5d"
dependencies: [1]
---

# Phase 2: Runnable App Features

## Overview

Xây app Node.js dependency-free và UI nhỏ để follower thực sự tạo đơn, payment mock, chuyển kitchen state và xem kết quả.

## Requirements

- Functional: catalog, order creation, stock rejection, payment approve/decline, kitchen queue/tick, completion, order lookup, UI checkout.
- Non-functional: deterministic injection cho clock/ID; explicit state transitions; JSON errors ổn định; no network dependency.

## Architecture

```text
Browser → HTTP router → OrderService
                      ├→ CatalogStore
                      ├→ OrderStore
                      ├→ PaymentService (in-process mock)
                      └→ KitchenQueue
```

HTTP contract: `GET /api/catalog`, `POST /api/orders`, `GET /api/orders/:id`, `POST /api/kitchen/tick`, `POST /api/orders/:id/complete`.

## Related Code Files

- Create: `package.json`, `src/domain/order.mjs`, `src/stores/*.mjs`, `src/services/*.mjs`
- Create: `src/http/app.mjs`, `src/server.mjs`, `public/index.html`, `public/app.js`, `public/styles.css`

## Implementation Steps

1. `feature/02-app-foundation`: package scripts, HTTP/static server, health endpoint; tag `feature-02-app-foundation-v2.0.0`.
2. `feature/03-order-domain`: catalog/order stores và guarded lifecycle; tag `feature-03-order-domain-v2.0.0`.
3. `feature/04-payment-mock`: approve/decline contract và events; tag `feature-04-payment-mock-v2.0.0`.
4. `feature/05-kitchen-worker`: deterministic queue/tick; tag `feature-05-kitchen-worker-v2.0.0`.
5. `feature/06-web-checkout`: UI tạo đơn, tick bếp, refresh status; tag `feature-06-web-checkout-v2.0.0`.
6. Mỗi slice chạy focused smoke/test, annotated tag trước, merge `--no-ff`, push sau gate.

## Success Criteria

- [ ] `npm start` mở UI và health API.
- [ ] Happy order đi `AWAITING_PAYMENT → CONFIRMED → IN_KITCHEN → READY → COMPLETED`.
- [ ] Hết hàng không charge; decline giữ order ở `PAYMENT_FAILED`.
- [ ] Kitchen tick không dùng sleep và không process sai order.

## Risk Assessment

Nếu UI làm domain coupling, giữ HTTP JSON contract làm authority và chỉ sửa adapter UI; không đưa business rule vào browser.
