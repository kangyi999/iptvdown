# txt.ps1
# 10个远程源列表
$urlList = @(
    "https://gitee.com/lwr851/live/raw/master/iptv.m3u",
    "https://gh-proxy.org/https://github.com/doubletree6/tvbox-iptv-subscription/raw/main/cn_all_tvbox_multi.txt",
    "http://110.mypressonline.com/cn/st.txt",
    "http://110.mypressonline.com/cn/web.txt",
    "https://gh-proxy.org/https://github.com/two2025/tv/raw/main/itvlist.txt",
    "https://gh-proxy.org/https://raw.githubusercontent.com/kangyi888/iptv-auto/main/output/out3.txt",
    "https://gh-proxy.com/raw.githubusercontent.com/fafa002/yf2025/refs/heads/main/yiyifafa.txt",
    "https://pastebin.com/raw/RV8wks5K",
    "https://gitee.com/zwssina/yunduanyuan/raw/master/SB",
    "https://gh-proxy.org/https://raw.githubusercontent.com/jn950/live/main/tv/pllive.txt"
)

$outputDir = "output"

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

for ($i = 0; $i -lt $urlList.Count; $i++) {
    $num = $i + 1
    $outFile = Join-Path $outputDir "$num.txt"
    $url = $urlList[$i]
    $retryCount = 1
    $success = $false

    # ========== 关键修复：每次下载前强制创建目录 ==========
    if (-not (Test-Path $outputDir)) {
        Write-Host "Create output directory"
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    for ($try = 0; $try -le $retryCount; $try++) {
        try {
            Write-Host "Attempt $($try+1): Downloading $url -> $outFile"
            Invoke-WebRequest -Uri $url -OutFile $outFile -Headers $headers -TimeoutSec 30 -UseBasicParsing
            $success = $true
            Write-Host "Download success $outFile"
            break
        }
        catch {
            Write-Host "Attempt $($try+1): Failed $url : $_"
            Start-Sleep -Seconds 2
        }
    }

    if(-not $success){
        Write-Host "All retry failed for $url, keep old file if exists, skip to next source"
    }
}
