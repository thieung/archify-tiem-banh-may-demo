# Quy Trình Branch, Tag Và Merge

Repository demo phát triển theo từng phần độc lập. Mỗi phần có feature branch, commit riêng, annotated tag riêng, sau đó mới được merge bằng merge commit về `main`.

## Release Map

| Phần | Branch | Annotated tag | Nội dung |
|---|---|---|---|
| 01 | `part/01-architecture` | `part-01-architecture-v1.0.0` | Architecture source, HTML và visual evidence |
| 02 | `part/02-workflow` | `part-02-workflow-v1.0.0` | Workflow source, HTML và visual evidence |
| 03 | `part/03-sequence` | `part-03-sequence-v1.0.0` | Sequence source, HTML và visual evidence |
| 04 | `part/04-dataflow` | `part-04-dataflow-v1.0.0` | Data Flow source, HTML và visual evidence |
| 05 | `part/05-lifecycle` | `part-05-lifecycle-v1.0.0` | Lifecycle source, HTML và visual evidence |
| 06 | `part/06-documentation` | `part-06-documentation-v1.0.0` | README, verification harness và release map |
| 07 | `part/07-repository-hygiene` | `part-07-repository-hygiene-v1.0.0` | Loại Finder metadata khỏi public Git history |
| 08 | `part/08-public-wording` | `part-08-public-wording-v1.0.0` | Xoá placeholder phát hành đã hết hiệu lực |
| Release | `main` | `v1.0.2` | Bản public tích hợp đủ tám phần |

## Merge Gate

Trước mỗi merge về `main`:

1. Chạy validation `showcase` cho JSON thuộc phần đó.
2. Xác nhận HTML được tạo từ candidate vừa validate.
3. Kiểm tra visual receipt và screenshots; không biến `visualReview: pending` thành human pass tự động.
4. Tạo annotated tag trên head của feature branch.
5. Merge bằng `git merge --no-ff` để giữ ranh giới của từng phần.
6. Sau merge cuối, chạy `./verify-demo.sh` trên `main` rồi mới tạo release tag.

Raw `*.visual-check.json` không thuộc public history vì có machine-local path. Screenshots và contact sheet là visual evidence có thể chia sẻ; người review có thể tạo receipt mới trên máy của họ.

## Kiểm Tra Lịch Sử

```bash
git log --graph --decorate --oneline --all
git tag --list --format='%(refname:short) %(objecttype) %(subject)'
git branch --list 'part/*'
```

## Câu Hỏi Chưa Rõ

- Remote public và chính sách ký tag bằng GPG/SSH chưa được chọn; các tag hiện tại là annotated local tags, chưa phải signed tags.
