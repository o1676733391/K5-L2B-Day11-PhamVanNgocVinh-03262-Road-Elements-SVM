# Hướng dẫn Nộp bài & Cấu trúc Thư mục Nộp — Ngày 11

**Học viên:** Phạm Văn Ngọc Vinh  
**MSHV:** 03262  
**Username `<tên>` quy ước:** `phamvanngocvinh`  
**Guideline:** Road v1.0  

---

## 1. 5 File Nộp Bài Cần Bàn Giao

| # | Tên file quy chuẩn | Mô tả | Trạng thái |
|---|---|---|---|
| 1 | `phamvanngocvinh-front.zip` | Export từ task Front trên CVAT (CVAT for images 1.1, **không kèm ảnh**) | Chờ export |
| 2 | `phamvanngocvinh-fisheye.zip` | Export từ task Fisheye trên CVAT (CVAT for images 1.1, **không kèm ảnh**) | Chờ export |
| 3 | `phamvanngocvinh-manifest.json` | Manifest do `road_check lint --manifest` tự động sinh ra | Tạo bằng script |
| 4 | `phamvanngocvinh-qc1-for-[tên_bạn].md` | Phiếu QC 1 đánh giá lô ảnh của bạn học được phân công | Điền tay sau khi QC bạn |
| 5 | `phamvanngocvinh-report.md` | Báo cáo cá nhân (đã điền thông tin và đính kèm 4 ảnh minh chứng) | Điền tay & đính kèm ảnh |

---

## 2. Các Lệnh Tiện Ích

### Kiểm tra toàn bộ bài nộp & sinh manifest (PowerShell):
```powershell
cd d:\VinAI\Day10\K5-L2B-Day11-PhamVanNgocVinh-03262-Road-Elements-SVM
.\submission\check_submission.ps1
```
*(Nếu là lần nộp lại sau Rework, thêm `-Revision 2`: `.\submission\check_submission.ps1 -Revision 2`)*

### Chạy thủ công từng lệnh:
1. **Self-test môi trường:**
   ```powershell
   $env:PYTHONPATH="src"; python -m road_lab.road_check selftest
   ```
2. **Lint & sinh Manifest:**
   ```powershell
   $env:PYTHONPATH="src"; python -m road_lab.road_check lint phamvanngocvinh-front.zip phamvanngocvinh-fisheye.zip --manifest submission/phamvanngocvinh-manifest.json --name phamvanngocvinh --revision 1
   ```
3. **(Tùy chọn) Chạy rowanchor để điền mục 8 của báo cáo:**
   ```powershell
   $env:PYTHONPATH="src"; python -m road_lab.rowanchor phamvanngocvinh-front.zip --image A01
   ```

---

## 3. Thư mục con
- `screenshots/`: Thư mục lưu 4 ảnh chụp màn hình minh chứng cho Mục 6 của file report.
- `r1/`: Thư mục lưu trữ bản xuất lần đầu (revision 1) gồm 2 zip và manifest-r1 trong trường hợp bạn kiểm yêu cầu Rework.
