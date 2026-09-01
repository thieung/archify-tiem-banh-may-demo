# Demo Archify: Tiệm bánh Mây

Đây là một **thiết kế giả định** dùng xuyên suốt để học Archify. Nó không phải source code của một ứng dụng đang chạy, không chứng minh payment hay giao hàng hoạt động, và không đại diện cho production architecture.

## Câu chuyện chung

Khách đặt bánh trên website. Hệ thống kiểm tra món còn bán, tạo đơn, gửi yêu cầu thanh toán, báo bếp chuẩn bị và cập nhật trạng thái cho khách.

Cùng một câu chuyện được nhìn qua năm câu hỏi:

| Loại sơ đồ | Câu hỏi |
|---|---|
| Architecture | Hệ thống gồm những phần nào và chúng kết nối ra sao? |
| Workflow | Nhân viên xử lý một đơn từ lúc nhận đến lúc hoàn tất thế nào? |
| Sequence | Khi khách bấm đặt bánh, ai gọi ai theo thứ tự nào? |
| Data Flow | Thông tin khách, đơn hàng và thanh toán đi đâu? |
| Lifecycle | Một đơn bánh chuyển qua những trạng thái nào? |

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

Script chạy `doctor`, validate cả năm JSON ở quality `showcase`, rồi kiểm tra raw visual receipts nếu chúng tồn tại. Nó không thay thế bước con người xem screenshots.

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

## Kết quả đã kiểm tra

Môi trường kiểm tra: macOS, ngày 2026-09-01, packaged Archify stable `v2.16.0`.

| Mode | Showcase | Composition | Visual automation | Human review | Source SHA-256 | HTML SHA-256 |
|---|---:|---:|---:|---|---|---|
| Architecture | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `83d46ede7ff2…` | `22272ca3dc95…` |
| Workflow | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass, có nhánh hoàn tiền dài | `e72b51ef68e4…` | `e274fec99f69…` |
| Sequence | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `ea420f7a296d…` | `5fc50291ba9a…` |
| Data Flow | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `d4b88cfd9c12…` | `8238efb0d8e5…` |
| Lifecycle | 9/9 | 0 lỗi, 0 cảnh báo | pass | pass | `ddec677be2b9…` | `b5c7f7d1a8c8…` |

`visual-check` luôn ghi `visualReview: "pending"`: nó chỉ đo containment và chụp evidence. Trạng thái human review ở bảng trên đến từ việc xem riêng các ảnh light/dark ở 1440×900 và 2048×1320. Workflow vẫn đọc được và không overflow; nhánh hoàn tiền được giữ dài có chủ đích để tách khỏi main path.

Raw `*.visual-check.json` có absolute path của máy chạy nên được `.gitignore`; hãy tạo lại local bằng lệnh trên khi review release. Screenshots, contact sheet và HTML không chứa private home path trong lần kiểm tra này.

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
