---
phase: 4
title: "Prompts and CURRENT diagrams"
status: pending
priority: P1
effort: "1.5d"
dependencies: [3]
---

# Phase 4: Prompts And CURRENT Diagrams

## Overview

Mỗi diagram mode có một branch học độc lập chứa exact prompt, evidence map, typed JSON, delivered HTML và visual evidence sinh từ app source đã test.

## Requirements

- Functional: Architecture, Workflow, Sequence, Data Flow, Lifecycle trả lời năm câu hỏi hẹp.
- Non-functional: tối đa 12 primary nodes, one main path, labels tiếng Việt; `CURRENT` chỉ cho fact từ source/tests; unknown ghi rõ.

## Related Code Files

- Create: `prompts/01-architecture-current.md` … `prompts/05-lifecycle-current.md`
- Create: `evidence/diagrams/{architecture,workflow,sequence,dataflow,lifecycle}.md`
- Create: `diagrams/current/sources/*.json`, `diagrams/current/rendered/*`
- Modify: `verify-demo.sh`

## Implementation Steps

1. `prompt/01-architecture-current`: system components/relationships; tag `prompt-01-architecture-current-v2.0.0`.
2. `prompt/02-workflow-current`: checkout decisions/failure paths; tag `prompt-02-workflow-current-v2.0.0`.
3. `prompt/03-sequence-current`: `POST /api/orders` call order; tag `prompt-03-sequence-current-v2.0.0`.
4. `prompt/04-dataflow-current`: contact/order/payment/kitchen data paths; tag `prompt-04-dataflow-current-v2.0.0`.
5. `prompt/05-lifecycle-current`: guarded order states; tag `prompt-05-lifecycle-current-v2.0.0`.
6. Với từng branch: chạy app tests → hoàn thành source-truth map → author candidate → check update once after first candidate → validate → deliver → visual-check → human inspect → evidence summary → tag → merge.

## Success Criteria

- [ ] Exact prompt copy-ready và liệt kê files agent phải inspect.
- [ ] Evidence map nối từng node/edge/message/state tới source/test/event cụ thể.
- [ ] 5 source-truth maps không có unsupported `CURRENT` fact.
- [ ] 5 × 9/9 showcase, 0 composition errors/warnings.
- [ ] Containment/captures pass; human review status thật, không sửa raw receipt.
- [ ] `CURRENT` diagram không giữ fictional external service từ proposed v1 nếu app không có.

## Risk Assessment

Nếu validation geometry fail, sửa đúng diagnosed subject; nếu evidence thiếu, giảm topology hoặc ghi UNKNOWN, không bịa component để giống proposed diagram.
