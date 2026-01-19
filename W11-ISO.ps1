# $url = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENT_CONSUMER_x64FRE_zh-cn.iso"
# aria2c -x16 -s16 -k1M -c --file-allocation=trunc --summary-interval=1 --console-log-level=notice --show-console-readout=true -o windows11.iso $url

$ESDUrl = "http://dl.delivery.mp.microsoft.com/filestreamingservice/files/5c395b9e-cda3-4e1a-83f0-20a922248656/26200.7623.260109-1650.25h2_ge_release_svc_refresh_CLIENTBUSINESS_VOL_x64FRE_zh-cn.esd"
$ESDFile = "windows11.esd"
aria2c -x16 -s16 -k1M -c --file-allocation=trunc --summary-interval=1 --console-log-level=notice --show-console-readout=true -o $ESDFile $ESDUrl

$BaseUri = "https://github.com/abbodi1406/WHD/raw/master/scripts/esd-decrypter-wimlib-"
$CurrentVersion = 66
$NextVersion = $CurrentVersion + 1
while ($true) {
    $TestUrl = "${BaseUri}${NextVersion}.7z"
    try {
        $Response = Invoke-WebRequest -Uri $TestUrl -Method Head -TimeoutSec 10 -ErrorAction Stop
        if ($Response.StatusCode -eq 200) {
            $CurrentVersion = $NextVersion
            $NextVersion++
        } else { break }
    } catch {
        break
    }
}
Start-Sleep -Seconds 5
$DecrypterFile = "esd-decrypter-wimlib-${CurrentVersion}.7z"
$DecrypterUrl = "${BaseUri}${CurrentVersion}.7z"

if (-not (Test-Path $DecrypterFile)) {
    Invoke-WebRequest -Uri $DecrypterUrl -OutFile $DecrypterFile -UseBasicParsing
}

$SevenZip = "7z.exe"
& $SevenZip x $DecrypterFile -y | Out-Null

$filePath = ".\decrypt.cmd"

if (Test-Path "decrypt.cmd") {
    $content = Get-Content "decrypt.cmd"
    $newContent = $content -replace '^set AutoStart=0$', 'set AutoStart=1'
    $newContent | Set-Content "decrypt.cmd" -Encoding Default
    Write-Host "✅ decrypt.cmd: AutoStart 已设为 1" -ForegroundColor Green
} else {
    Write-Warning "⚠️ decrypt.cmd 不存在，跳过修改"
}

if (Test-Path "DecryptConfig.ini") {
    $content = Get-Content "DecryptConfig.ini"
    $newContent = $content -replace '^(AutoStart\s*=\s*)0$', '$11'
    $newContent | Set-Content "DecryptConfig.ini" -Encoding UTF8
    Write-Host "✅ DecryptConfig.ini: AutoStart 已设为 1" -ForegroundColor Green
} else {
    Write-Warning "⚠️ DecryptConfig.ini 不存在，跳过修改"
}

cmd /c "`"$pwd\$filePath`" `"$pwd\$ESDFile`""

$GeneratedISO = Get-ChildItem -Path . -Filter "*.iso" -File | 
                Where-Object { $_.Name -like "*CLIENTBUSINESS_VOL*x64FRE*zh-cn.iso" } |
                Sort-Object LastWriteTime -Descending | 
                Select-Object -First 1

if ($GeneratedISO) {
    $TargetISO = "windows11.iso"
    if (Test-Path $TargetISO) { Remove-Item $TargetISO -Force }
    Move-Item -Path $GeneratedISO.FullName -Destination $TargetISO -Force
} else {
    Write-Warning "NO ISO"
}

if (Test-Path $ESDFile) {
    Remove-Item $ESDFile -Force
}

$TempFolders = @("ISOFOLDER", "mount", "wimlib-*")
foreach ($folder in $TempFolders) {
    Get-ChildItem -Directory -Filter $folder -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Recurse -Force
    }
}
Start-Sleep -Seconds 5
