<# 
Title: Local Computer System Information
By: Alan Newingham
Date: 11/29/2020
Git: https://github.com/01000001-01001110/SystemInfo
Notes: https://automateanddeploy.com/index.php/2020/12/01/gathering-local-system-information/ 
#>
$title = "Black"
$background = "White"
$foreground = "Black"
Clear-Host
$monitors = Get-CimInstance Win32_VideoController
$computerSystem = Get-CimInstance CIM_ComputerSystem
Write-Host "Gathering information..."
$unc = $env:USERPROFILE
$RAM = Get-CimInstance -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem"
$freeRAM = [math]::Round($RAM.FreePhysicalMemory/1MB, 2)
$usedRAM = [math]::Round(($RAM.TotalVisibleMemorySize - $RAM.FreePhysicalMemory)/1MB, 2)
$InstallDate = (Get-CimInstance Win32_OperatingSystem -ComputerName $_.Name).InstallDate
$LastBootUpTime = (Get-CimInstance Win32_OperatingSystem -ComputerName $_.Name).LastBootUpTime
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Write-Host "Nearly There!!"
$userlist = Get-ChildItem -Path "C:\Users\" 
$network = Get-NetIPAddress -AddressFamily IPv4 | Where-Object -FilterScript { $_.PrefixOrigin -eq "Dhcp" }
$localadmin = Get-LocalGroupMember -Group "Administrators"
$networkdrives = Get-SmbMapping #Get-PSDrive -PSProvider FileSystem 
$OS = Get-CimInstance -class Win32_OperatingSystem
Write-Host "Clearing Screen..."
$OS_Architecture = $OS.OSArchitecture
$OS_WindowsDirectory = $OS.WindowsDirectory
$OS_Version = $OS.Version
Clear-Host

Write-Host
Write-Host
Write-Host

Write-Host "System Information" -BackgroundColor $title -ForegroundColor $background
Write-Host "Device Name: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
$computerSystem.Name 
Write-Host "Operating System: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
$OS.Caption 
Write-Host "Service Pack: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
$computerOS.ServicePackMajorVersion
Write-Host "Last Boot: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $LastBootUpTime 
Write-Host "OS Install Date: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $InstallDate
Write-Host "Operating System Version: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $OS_Version  
Write-Host "OS Architecture: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $OS_Architecture
Write-Host "Manufacturer: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $computerSystem.Manufacturer 
Write-Host "Model: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $computerSystem.Model
Write-Host "Serial Number: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $computerBIOS.SerialNumber
Write-Host "CPU: "  -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $computerCPU.Name + $computerCPU.MaxClockSpeed
Write-Host "HDD Capacity: "   -NoNewline -BackgroundColor $background -ForegroundColor $foreground
"{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
Write-Host "HDD Space: "  -NoNewline -BackgroundColor $background -ForegroundColor $foreground
"{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
Write-Host "Memory/RAM: "  -NoNewline -BackgroundColor $background -ForegroundColor $foreground
"{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" 
Write-Host "Free Memory: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $freeRAM
Write-Host "Used: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $usedRAM
Write-Host "Monitor Count: "  -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $monitors.count  
Write-Host "Screen Size: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $monitors.VideoModeDescription
Write-Host "User logged In: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $computerSystem.UserName
Write-Host "The total size of the current logged in profile is: "  -NoNewline -BackgroundColor $background -ForegroundColor $foreground
"{0:N2} GB" -f ((Get-ChildItem $unc -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum/ 1GB)
Write-Host "User List: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $userlist.Name
Write-Host "Local Administrators: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $localadmin.Name
Write-Host "Network Drives: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
Write-Host $networkdrives.LocalPath $networkdrives.RemotePath
Write-Host "IPv4 Address: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
$network.IPAddress
Write-Host "Windows Directory: " -NoNewline -BackgroundColor $background -ForegroundColor $foreground
$OS_WindowsDirectory
""
Write-Host "For a list of installed software, type " -NoNewline
Write-Host "Get-CimInstance -Class Win32_Product" -BackgroundColor Green -ForegroundColor Black
