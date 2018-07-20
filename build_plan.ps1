# Get device drivers
Get-WmiObject Win32_SystemDriver | Select-Object @{Name="Device Drivers";Expression={$_.DisplayName}}, Name,@{n="Version";e={(Get-Item $_.pathname).VersionInfo.FileVersion}} | Export-Csv drivers.csv -NoTypeInformation

# Get Services
#Get-WmiObject -Class win32_service | Select-Object DisplayName, StartMode, State | Export-Csv services.csv -NoTypeInformation
Get-WmiObject -Class win32_service | Select-Object @{Name="Services/Daemons";Expression={$_.DisplayName}}, StartMode | Export-Csv services.csv -NoTypeInformation

# Get Installed Hotfixes, Applications, and Updates
#Get-Hotfix | Select-Object CSName, HotFixID, Description | Export-Csv Hotfixes.csv -NoTypeInformation
Get-Hotfix | Select-Object @{Name="Computer Name";Expression={$_.CSName}}, HotFixID, Description | Export-Csv Hotfixes.csv -NoTypeInformation

Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*  |
Select-Object DisplayName, DisplayVersion,
  @{ n="KB Number"; e={
     if ($_.DisplayName -match '.*(KB\d\d\d\d\d).*') {
       $_.DisplayName -Replace '^.*(KB\d\d\d\d\d\d\d).*$', '$1'
     } else { "NA" }
  }
} |
Export-Csv applications.csv -NoTypeInformation
