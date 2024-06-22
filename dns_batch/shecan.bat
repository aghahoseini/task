setlocal EnableDelayedExpansion
fsutil Dirty Query %SystemDrive% > nul && goto:[RunAs]
echo CreateObject^("Shell.Application"^). ^
ShellExecute "%~0","+","","RunAs",1 > "%Temp%\+.vbs" && "%Temp%\+.vbs" & Exit
:[RunAs]

netsh dnsclient delete dnsserver "WI-FI" all
netsh interface ipv4 add dnsserver "Wi-Fi" address=178.22.122.100 index=1
netsh interface ipv4 add dnsserver "Wi-Fi" address=185.51.200.2 index=2
