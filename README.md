# Demo Archify: Tiệm bánh Mây

Đây là một **thiết kế giả định** dùng xuyên suốt để học Archify. Nó không phải source code của một ứng dụng đang chạy, không chứng minh payment hay giao hàng hoạt động, và không đại diện cho production architecture.

## Câu chuyện chung

Khách đặt bánh trên website. Hệ thống kiểm tra món còn bán, tạo đơn, gửi yêu cầu thanh toán, báo bếp chuẩn bị và cập nhật trạng thái cho khách.

Cùng một câu chuyện được nhìn qua mười câu hỏi:

| Loại sơ đồ | Câu hỏi |
|---|---|
| Architecture | Hệ thống gồm những phần nào và chúng kết nối ra sao? |
| Workflow | Nhân viên xử lý một đơn từ lúc nhận đến lúc hoàn tất thế nào? |
| Sequence | Khi khách bấm đặt bánh, ai gọi ai theo thứ tự nào? |
| Data Flow | Thông tin khách, đơn hàng và thanh toán đi đâu? |
| Lifecycle | Một đơn bánh chuyển qua những trạng thái nào? |
| ERD | Dữ liệu một đơn bánh nằm ở những bảng nào và nối với nhau qua khóa nào? |
| Class | OrderService phụ thuộc vào những kiểu nào khi xử lý thanh toán? |
| Tree | Tính năng đặt bánh online gồm những phần nào, phần nào thuộc phần nào? |
| Timeline | Sự cố thanh toán buổi tối diễn ra theo mốc thời gian nào? |
| Waterfall | Một request `POST /orders` tốn thời gian ở bước nào? |

Cả mười sơ đồ được author và kiểm tra bằng Archify `3.1.0`. Timeline và Waterfall dùng số liệu minh họa và khai báo `meta.evidence: "illustrative"`; không lấy từ log hay trace thật.

## Cấu trúc

```text
.
|-- sources/     # Typed JSON do agent author
`-- rendered/    # HTML đã deliver, visual receipts và screenshots
```

Lịch sử Git được tách theo từng diagram mode và documentation, có annotated tag trước khi merge về `main`. Xem [RELEASES.md](RELEASES.md) để biết branch, tag và merge gate.

Mỗi file JSON là nguồn có thể review. Mỗi file HTML là artifact độc lập, mở trực tiếp trong browser, có dark/light theme. Các label nghiệp vụ viết bằng tiếng Việt; một số control của viewer vẫn dùng tiếng Anh theo renderer hiện tại.

## Điều kiện trước khi chạy

- Node.js 18 trở lên.
- Skill Archify `3.1.0` trở lên đã được cài cho agent hoặc repository hiện tại.
- Chạy lệnh từ thư mục gốc repository.

Kiểm tra runtime:

```bash
npx -y skills add tt-a1i/archify --skill archify --agent codex --copy --yes
node .agents/skills/archify/bin/archify.mjs doctor
```

Lệnh trên là project-local cho Codex. Đổi `--agent` theo agent của bạn hoặc thêm `--global` nếu muốn cài global. Các lệnh bên dưới mặc định dùng bản global của Codex; có thể truyền `ARCHIFY_SKILL_ROOT` để chọn package khác.

Chạy toàn bộ verification của demo bằng một lệnh:

```bash
./verify-demo.sh
```

Script kiểm tra Archify là bản `3.1.0` trở lên, chạy `doctor`, validate cả mười JSON ở quality `showcase`, rồi kiểm tra raw visual receipts nếu chúng tồn tại. Nó không thay thế bước con người xem screenshots.

## Tái tạo một sơ đồ

Ví dụ với Architecture:

```bash
ARCHIFY_SKILL_ROOT="${ARCHIFY_SKILL_ROOT:-$HOME/.agents/skills/archify}"

node "$ARCHIFY_SKILL_ROOT/bin/archify.mjs" finalize \
  architecture \
  sources/tiem-banh-may.architecture.json \
  rendered/tiem-banh-may.architecture.html \
  --quality showcase \
  --json

node "$ARCHIFY_SKILL_ROOT/bin/archify.mjs" visual-check \
  rendered/tiem-banh-may.architecture.html \
  --json
```

`finalize` chạy lần lượt validate, deliver, strict check và browser-check, dừng ở bước đầu tiên không qua. Thay `architecture` và tên file bằng `workflow`, `sequence`, `dataflow`, `lifecycle`, `erd`, `class`, `tree`, `timeline` hoặc `waterfall` để chạy các artifact còn lại. Mỗi JSON khai báo `meta.output` trỏ tới file HTML tương ứng trong `rendered/`.

`visual-check` không ghi đè ảnh cũ mà nó không tạo ra. Khi chạy lại trên một bản clone, xoá `rendered/<tên>.visual-check.*` trước.

## Kết quả đã kiểm tra

Môi trường kiểm tra: macOS, ngày 2026-10-17, Archify `v3.1.0`.

| Mode | `finalize` showcase | Diagnostics | Visual automation | Human review | Source SHA-256 | HTML SHA-256 |
|---|---|---:|---:|---|---|---|
| Architecture | pass | 0 | pass | pending | `be1b10ce05e1…` | `ab06b7e206bd…` |
| Workflow | pass | 0 | pass | pending | `f0f2ff1d396c…` | `5112e7216a45…` |
| Sequence | pass | 0 | pass | pending | `6b85494348c9…` | `3b43076d035a…` |
| Data Flow | pass | 0 | pass | pending | `adbc67f27e0d…` | `0e6c2fd1486e…` |
| Lifecycle | pass | 0 | pass | pending | `ebeb5855dd15…` | `c0c0f05c759c…` |
| ERD | pass | 0 | pass | pending | `67dda5b3e1b8…` | `3545314edace…` |
| Class | pass | 0 | pass | pending | `070ca48fd0a7…` | `beba86965a8c…` |
| Tree | pass | 0 | pass | pending | `b5dfde57c4f4…` | `e0ee7af9a7ac…` |
| Timeline | pass | 0 | pass | pending | `063d678b193b…` | `626a9bc5c646…` |
| Waterfall | pass | 0 | pass | pending | `757ce325d93d…` | `d200b632d063…` |

`finalize` pass nghĩa là validate, deliver, strict check và browser-check đều qua. `visual-check` đo containment và chụp ảnh light/dark ở 1440×900 và 2048×1320 vào `rendered/`, nhưng luôn ghi `visualReview: "pending"`: chỉ người thật xem ảnh mới đổi được trạng thái human review.

Raw `*.visual-check.json`, cùng các receipt `*.finalize.json`, `*.finalize-summary.json`, `*.browser-check.json` và `*.delivery.json`, có absolute path của máy chạy nên được `.gitignore`; hãy tạo lại local bằng lệnh trên khi review release. Screenshots, contact sheet và HTML không chứa private home path trong lần kiểm tra này.

## Prompt để tự làm lại

```text
Hãy dùng skill Archify để vẽ [TYPE] cho một tiệm bánh online.

Câu hỏi người đọc cần trả lời:
[MỘT CÂU HỎI HẸP]

Facts được phép dùng:
[DÁN BRIEF HOẶC LIỆT KÊ FILE SOURCE ĐÃ KIỂM TRA]

Phân loại rõ CURRENT / OBSERVED / PROPOSED / UNKNOWN.
Không tự thêm service, bước xử lý hay nhánh lỗi thiếu evidence.
Author typed JSON, chạy finalize ở quality showcase,
sau đó chạy visual-check. Báo riêng kết quả kiểm tra sơ đồ và trạng thái
test của ứng dụng; không đánh đồng hai việc này.
```

## Giới hạn

- Demo chứng minh pipeline author → finalize → visual evidence của Archify.
- Demo không chạy một ứng dụng Tiệm bánh Mây thật.
- `9/9 showcase` nói về artifact sơ đồ, không nói business flow đã chạy thành công.
- Khi áp dụng cho repo thật, agent phải đọc repository evidence và ghi rõ phần chưa tìm thấy.
- Không dùng sơ đồ để thay thế unit, integration hoặc end-to-end test.

## Nguồn

- [Archify repository](https://github.com/tt-a1i/archify)
- [Archify guide](https://tt-a1i.github.io/archify/guide.html)
