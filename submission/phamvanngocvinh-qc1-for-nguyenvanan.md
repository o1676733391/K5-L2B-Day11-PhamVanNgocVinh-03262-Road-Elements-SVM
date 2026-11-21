# Phiếu QC 1 — Road v1.0

Lô được kiểm (học viên): nguyenvanan                    Người kiểm (học viên): Phạm Văn Ngọc Vinh (03262)  
Ngày: 21/11/2026                                        Phiên bản guideline: Road v1.0  
File được kiểm (tên + `revision` trong manifest): nguyenvanan-manifest.json (revision 1)  
Số ảnh kiểm: 20 / 20 ảnh bắt buộc (+ 0 ảnh thêm)        Số nhãn đã kiểm (shape + tag): 169  

## Tổng hợp theo mã
| Mã | Loại lỗi | Số mục kiểm | Số lỗi | Mức |
| --- | --- | ---: | ---: | --- |
| QC1-01 tag camera | sai thuộc tính / bỏ sót | 80 | 1 | nặng |
| QC1-02 đủ L1, R1 | bỏ sót | 32 | 0 | nặng |
| QC1-03 position | sai thuộc tính / thừa | 41 | 0 | nặng |
| QC1-04 tâm vạch, chiều, điểm dừng | sai phạm vi / bỏ sót | 41 | 2 | chính |
| QC1-05 vạch đứt, che | sai phạm vi / sai thuộc tính | 41 | 1 | chính |
| QC1-06 style, color, kind | sai thuộc tính | 41 | 0 | chính |
| QC1-07 vùng lái | sai phạm vi / bỏ sót / thừa | 33 | 0 | chính |
| QC1-08 đèn, màu | bỏ sót / sai phạm vi / sai thuộc tính | 8 | 1 | nặng / chính |
| QC1-09 facing, type, group, biển phụ | sai thuộc tính | 15 | 0 | chính |
| QC1-10 hình in, đủ biển | bỏ sót / sai phạm vi | 7 | 0 | chính |
| QC1-11 fisheye | sai phạm vi / sai thuộc tính | 28 | 0 | chính |
| QC1-12 file | lỗi file | 169 | 0 | nhẹ / nặng |

## Danh sách lỗi (mỗi lỗi một dòng)
| # | Mã | Ảnh | Nhãn (label, id) | Mức | Mô tả ngắn |
| --- | --- | --- | --- | --- | --- |
| 1 | QC1-01 | A01 | tag:camera | nặng | camera = fisheye_front, đúng là front (sai tag ảnh) |
| 2 | QC1-04 | A01 | lane#1@(665,430) | chính | vẽ ngược chiều (từ xa về gần; phải từ gần xe ra xa) |
| 3 | QC1-04 | A01 | lane#2@(126,725) | chính | lệch tối đa 12.0 px so với tâm vạch (ngưỡng cho phép ≤ 5 px) |
| 4 | QC1-05 | A01 | lane#0@(450,715)+lane#5@(514,572) | chính | một vạch đứt bị tách thành 2 polyline riêng biệt (phải là 1 polyline) |
| 5 | QC1-08 | A07 | traffic_light#3@(700,200) | nặng | color = green, màu đúng thực tế đang sáng là red trên đèn hướng về xe |

## Ca mơ hồ
| Ảnh | Câu hỏi cho lead | Lời đáp (nếu có) |
| --- | --- | --- |
| A08 | Cụm đèn phụ ở xa x=950, y=260 có kích thước 3x6 px (< 8 px) có cần bắt buộc gán không? | Lead xác nhận: Đèn/biển < 8 px là tùy chọn, không tính là lỗi thiếu nhãn, lint chỉ cảnh báo mức nhẹ. |

## Quyết định
Lỗi nặng: 2   Lỗi chính: 3 / 169 nhãn = 1.8%   Lỗi nhẹ: 1   Ca chờ lead: 0  
Quyết định (Release / Hold / Rework): **Rework**  
Lý do (theo luật của phiếu): Có 2 lỗi nặng (QC1-01 sai tag camera và QC1-08 sai màu đèn hướng về xe). Theo luật của Phiếu QC 1: có ít nhất 1 lỗi nặng $\rightarrow$ **Rework**.

---
*Ghi chú quy tắc quyết định:*
- **Rework**: Khi có ít nhất 1 lỗi nặng HOẶC tỉ lệ lỗi chính > 5.0% tổng số nhãn đã kiểm.
- **Hold**: Khi còn ca mơ hồ chưa có lời đáp ảnh hưởng tới kết luận.
- **Release**: Không có lỗi nặng và tỉ lệ lỗi chính <= 5.0%.
