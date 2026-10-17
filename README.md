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

Năm loại đầu được author và kiểm tra bằng Archify `2.16.0`. Năm loại sau (ERD, Class, Tree, Timeline, Waterfall) có từ Archify `3.1.0` và được kiểm tra bằng bản đó. Timeline và Waterfall dùng số liệu minh họa và khai báo `meta.evidence: "illustrative"`; không lấy từ log hay trace thật.

## Cấu trúc

```text
.
|-- sources/     # Typed JSON do agent author
`-- rendered/    # HTML đã deliver, visual receipts và screenshots
```

Lịch sử Git được tách theo từng diagram mode và documentation, có annotated tag trước khi merge về `main`. Xem [RELEASES.md](RELEASES.md) để biết branch, tag và merge gate.

Mỗi file JSON là nguồn có thể review. Mỗi file HTML là artifact độc lập, mở trực tiếp trong browser, có dark/light theme. Các label nghiệp vụ viết bằng tiếng Việt; một số control của viewer vẫn dùng tiếng Anh theo renderer hiện tại.

## Điều kiện trước khi chạy

- Node.js hoạt động.
- Skill Archify đã được cài cho agent hoặc repository hiện tại.
- Chạy lệnh từ thư mục gốc workspace.

Kiểm tra runtime:

```bash
npx -y skills add tt-a1i/archify --skill archify --agent codex --copy --yes
node .agents/skills/archify/bin/archify.mjs doctor
```

Lệnh trên là project-local cho Codex. Đổi `--agent` theo agent của bạn hoặc thêm `--global` nếu muốn cài global. Các lệnh tái tạo bên dưới mặc định dùng bản global của Codex; có thể truyền `ARCHIFY_SKILL_ROOT` để chọn package khác.

Chạy toàn bộ verification của demo bằng một lệnh:

```bash
./demos/archify-tiem-banh-may/verify-demo.sh
```

Script chạy `doctor`, validate cả mười JSON ở quality `showcase`, rồi kiểm tra raw visual receipts nếu chúng tồn tại. Năm JSON đầu dùng Archify tại `ARCHIFY_SKILL_ROOT`; năm JSON sau cần Archify 3.1.0 trở lên tại `ARCHIFY_V3_SKILL_ROOT` (mặc định trùng `ARCHIFY_SKILL_ROOT`). Script dừng với thông báo rõ nếu bản 3.x không đủ:

```bash
ARCHIFY_V3_SKILL_ROOT=/path/to/archify-3.1.0/archify ./verify-demo.sh
```

 Nó không thay thế bước con người xem screenshots.

## Tái tạo một sơ đồ

Ví dụ với Architecture:

```bash
ARCHIFY_SKILL_ROOT="${ARCHIFY_SKILL_ROOT:-$HOME/.agents/skills/archify}"

node "$ARCHIFY_SKILL_ROOT/bin/archify.mjs" validate \
  architecture \
  demos/archify-tiem-banh-may/sources/tiem-banh-may.architecture.json \
  --quality showcase \
  --json

node "$ARCHIFY_SKILL_ROOT/bin/archify.mjs" deliver \
  architecture \
  demos/archify-tiem-banh-may/sources/tiem-banh-may.architecture.json \
  demos/archify-tiem-banh-may/rendered/tiem-banh-may.architecture.html \
  --quality showcase \
  --json

node "$ARCHIFY_SKILL_ROOT/bin/archify.mjs" visual-check \
  demos/archify-tiem-banh-may/rendered/tiem-banh-may.architecture.html \
  --json
```

Thay `architecture` và tên file bằng `workflow`, `sequence`, `dataflow` hoặc `lifecycle` để chạy bốn artifact còn lại.

Với năm loại mới, dùng `finalize` của Archify 3.1.0. Lệnh này chạy validate, deliver, strict check và browser-check, dừng ở bước đầu tiên không qua:

```bash
ARCHIFY_V3_SKILL_ROOT="${ARCHIFY_V3_SKILL_ROOT:-$HOME/.agents/skills/archify}"

node "$ARCHIFY_V3_SKILL_ROOT/bin/archify.mjs" finalize \
  erd \
  sources/tiem-banh-may.erd.json \
  rendered/tiem-banh-may.erd.html \
  --quality showcase \
  --json

node "$ARCHIFY_V3_SKILL_ROOT/bin/archify.mjs" visual-check \
  rendered/tiem-banh-may.erd.html \
  --json
```

Thay `erd` bằng `class`, `tree`, `timeline` hoặc `waterfall`. Mỗi JSON khai báo `meta.output` trỏ tới file HTML tương ứng trong `rendered/`, nên chạy lệnh từ thư mục gốc repository.

## Kết quả đã kiểm tra

Môi trường kiểm tra: macOS, ngày 2026-09-01, packaged Archify stable `v2.16.0`.

| Mode | Showcase | Composition | Visual automation | Human review | Source SHA-256 | HTML SHA-256 |
|---|---:|---:|---:|---|---|---|
| Architecture | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `83d46ede7ff2…` | `22272ca3dc95…` |
| Workflow | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass, có nhánh hoàn tiền dài | `e72b51ef68e4…` | `e274fec99f69…` |
| Sequence | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `ea420f7a296d…` | `5fc50291ba9a…` |
| Data Flow | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `d4b88cfd9c12…` | `8238efb0d8e5…` |
| Lifecycle | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `ddec677be2b9…` | `b5c7f7d1a8c8…` |

Năm loại mới, kiểm tra ngày 2026-10-17 trên macOS bằng Archify `v3.1.0`:

| Mode | `finalize` showcase | Diagnostics | Visual automation | Human review | Source SHA-256 | HTML SHA-256 |
|---|---|---:|---:|---|---|---|
| ERD | pass | 0 | pass | pending | `67dda5b3e1b8…` | `3545314edace…` |
| Class | pass | 0 | pass | pending | `070ca48fd0a7…` | `beba86965a8c…` |
| Tree | pass | 0 | pass | pending | `b5dfde57c4f4…` | `e0ee7af9a7ac…` |
| Timeline | pass | 0 | pass | pending | `063d678b193b…` | `626a9bc5c646…` |
| Waterfall | pass | 0 | pass | pending | `757ce325d93d…` | `d200b632d063…` |

`finalize` pass nghĩa là validate, deliver, strict check và browser-check đều qua. Ảnh light/dark ở 1440×900 và 2048×1320 nằm trong `rendered/`; human review cho năm loại này vẫn chờ tác giả xem ảnh.

`visual-check` luôn ghi `visualReview: "pending"`: nó chỉ đo containment và chụp evidence. Trạng thái human review ở bảng trên đến từ việc xem riêng các ảnh light/dark ở 1440×900 và 2048×1320. Workflow vẫn đọc được và không overflow; nhánh hoàn tiền được giữ dài có chủ đích để tách khỏi main path.

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
Author typed JSON, validate ở quality showcase, deliver HTML atomically,
sau đó chạy visual-check. Báo riêng kết quả kiểm tra sơ đồ và trạng thái
test của ứng dụng; không đánh đồng hai việc này.
```

## Giới hạn

- Demo chứng minh pipeline author → validate → deliver → visual evidence của Archify.
- Demo không chạy một ứng dụng Tiệm bánh Mây thật.
- `9/9 showcase` nói về artifact sơ đồ, không nói business flow đã chạy thành công.
- Khi áp dụng cho repo thật, agent phải đọc repository evidence và ghi rõ phần chưa tìm thấy.
- Không dùng sơ đồ để thay thế unit, integration hoặc end-to-end test.

## Nguồn

- [Archify repository](https://github.com/tt-a1i/archify)
- [Archify guide](https://tt-a1i.github.io/archify/guide.html)
