# Check Submission Script for Day 11 (Road Elements & SVM)
param (
    [int]$Revision = 1,
    [string]$PartnerName = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   KIEM TRA BAI NOP DAY 11 - ROAD ELEMENTS & SVM          " -ForegroundColor Cyan
Write-Host "   Hoc vien: Pham Van Ngoc Vinh (03262)                   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Kiem tra python environment
Write-Host "`n[1/5] Kiem tra moi truong Python & Self-test..." -ForegroundColor Yellow
$env:PYTHONPATH = "$RepoRoot\src"

try {
    $selftestOutput = python -m road_lab.road_check selftest 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[-] Selftest that bai! Chi tiet:" -ForegroundColor Red
        Write-Host $selftestOutput
        exit 1
    }
    Write-Host "[+] Selftest PASS!" -ForegroundColor Green
} catch {
    Write-Host "[-] Khong the thuc thi python! Kiem tra lai Python 3.11+ trong PATH." -ForegroundColor Red
    exit 1
}

# 2. Tim file zip front va fisheye
Write-Host "`n[2/5] Tim 2 file zip export tu CVAT..." -ForegroundColor Yellow
$Name = "phamvanngocvinh"
$FrontZipName = "$Name-front.zip"
$FisheyeZipName = "$Name-fisheye.zip"

$FrontZip = $null
$FisheyeZip = $null

if (Test-Path "$RepoRoot\$FrontZipName") { $FrontZip = "$RepoRoot\$FrontZipName" }
elseif (Test-Path "$ScriptDir\$FrontZipName") { $FrontZip = "$ScriptDir\$FrontZipName" }

if (Test-Path "$RepoRoot\$FisheyeZipName") { $FisheyeZip = "$RepoRoot\$FisheyeZipName" }
elseif (Test-Path "$ScriptDir\$FisheyeZipName") { $FisheyeZip = "$ScriptDir\$FisheyeZipName" }

if (-not $FrontZip -or -not $FisheyeZip) {
    Write-Host "[-] Chua tim thay du 2 file zip export tu CVAT!" -ForegroundColor Red
    if (-not $FrontZip) { Write-Host "    - Thieu file: $FrontZipName" -ForegroundColor Red }
    if (-not $FisheyeZip) { Write-Host "    - Thieu file: $FisheyeZipName" -ForegroundColor Red }
    Write-Host "    Huong dan: Export tu CVAT (CVAT for images 1.1, UNCHECK Save images) va copy vao repo root hoac thu muc submission/." -ForegroundColor Yellow
    exit 1
}

Write-Host "[+] Tim thay:" -ForegroundColor Green
Write-Host "    - Front:   $FrontZip" -ForegroundColor Gray
Write-Host "    - Fisheye: $FisheyeZip" -ForegroundColor Gray

# 3. Chay lint & tao manifest
Write-Host "`n[3/5] Chay road_check lint va tao manifest (Revision: $Revision)..." -ForegroundColor Yellow
$ManifestPath = "$ScriptDir\$Name-manifest.json"

$lintCmd = "python -m road_lab.road_check lint `"$FrontZip`" `"$FisheyeZip`" --manifest `"$ManifestPath`" --name `"$Name`" --revision $Revision"
Write-Host "Lenh: $lintCmd" -ForegroundColor DarkGray
Invoke-Expression $lintCmd

if ($LASTEXITCODE -ne 0) {
    Write-Host "[-] Lint bao loi! Vui long kiem tra chi tiet ben tren." -ForegroundColor Red
} else {
    Write-Host "[+] Lint chay thanh cong va da tao manifest: $ManifestPath" -ForegroundColor Green
}

# 4. Doc va kiem tra manifest JSON
Write-Host "`n[4/5] Kiem tra noi dung manifest..." -ForegroundColor Yellow
if (Test-Path $ManifestPath) {
    $manifestContent = Get-Content $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json
    $hasImages = $false
    foreach ($f in $manifestContent.files) {
        if ($f.contains_images -eq $true) {
            $hasImages = $true
            Write-Host "[-] CANH BAO NANG: File $($f.file) van chua anh (contains_images = true)!" -ForegroundColor Red
            Write-Host "    -> Phai export lai va BO TICK 'Save images'!" -ForegroundColor Red
        } else {
            Write-Host "    [OK] $($f.file): contains_images = false" -ForegroundColor Green
        }
    }

    $nangCount = $manifestContent.lint.nặng
    $chinhCount = $manifestContent.lint.chính
    $nheCount = $manifestContent.lint.nhẹ

    Write-Host "    Tong hop lint:" -ForegroundColor Cyan
    Write-Host "      - Nang:  $nangCount" -ForegroundColor $(if ($nangCount -eq 0) { "Green" } else { "Red" })
    Write-Host "      - Chinh: $chinhCount" -ForegroundColor Yellow
    Write-Host "      - Nhe:   $nheCount" -ForegroundColor Gray

    if ($nangCount -gt 0) {
        Write-Host "[-] LUU Y: Con $nangCount loi nang. Theo luat, loi nang se bi Rework tru khi QC1-02 duoc coach mien do khong thay vach tren anh." -ForegroundColor Red
    }
}

# 5. Kiem tra danh sach 5 file can nop
Write-Host "`n[5/5] Kiem tra danh sach 5 file nop bai..." -ForegroundColor Yellow

$ReportFile = "$ScriptDir\$Name-report.md"
$QC1Files = Get-ChildItem -Path $ScriptDir -Filter "$Name-qc1-for-*.md"

$checkList = @(
    @{ Name = "$FrontZipName"; Status = (Test-Path $FrontZip) },
    @{ Name = "$FisheyeZipName"; Status = (Test-Path $FisheyeZip) },
    @{ Name = "$Name-manifest.json"; Status = (Test-Path $ManifestPath) },
    @{ Name = "$Name-report.md"; Status = (Test-Path $ReportFile) },
    @{ Name = "$Name-qc1-for-<ten-ban>.md"; Status = ($QC1Files.Count -gt 0) }
)

$allReady = $true
foreach ($item in $checkList) {
    if ($item.Status) {
        Write-Host "    [x] $($item.Name)" -ForegroundColor Green
    } else {
        Write-Host "    [ ] $($item.Name) (CHUA CO)" -ForegroundColor Red
        $allReady = $false
    }
}

Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
if ($allReady) {
    Write-Host "XONG! Du 5 file de nop bai." -ForegroundColor Green
} else {
    Write-Host "CHUA DU! Hay hoan thien cac muc con thieu tren." -ForegroundColor Yellow
}
