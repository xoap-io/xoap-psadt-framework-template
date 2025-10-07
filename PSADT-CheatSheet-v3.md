# PSDT v3 Cheat Sheet

## Variables

```PowerSHell
$envCommonDesktop           # C:\Users\Public\Desktop
$envCommonPrograms          # C:\ProgramData\Microsoft\Windows\Start Menu\Programs
$envProgramFiles            # C:\Program Files
$envProgramFilesX86         # C:\Program Files (x86)
$envProgramData             # c:\ProgramData
$envUserDesktop             # c:\Users\{user currently logged in}\Desktop
$envUserStartMenuPrograms   # c:\Users\{user currently logged in}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
$envSystemDrive             # c:
$envWinDir                  # c:\windows
```

## Examples of exe installers

```PowerShell
Execute-Process -Path 'setup.exe' -Parameters '/quiet' -WaitForMsiExec:$true
Execute-Process -Path "$dirFiles\DirectX\Bin\setup.exe" -Parameters '/silent' -WindowStyle 'Hidden'
```

# Open Notepad.exe and don't wait for it to close

```PowerSHell
Execute-Process -Path "$envSystemRoot\notepad.exe" -NoWait 
```

## Examples of msi installers

```PowerShell
Execute-MSI -Action 'Install' -Path "$dirFiles\<application>.msi" -Parameters 'REBOOT=ReallySuppress /QN'
Execute-MSI -Action 'Install' -Path 'Discovery 2015.1.msi'
```

###  MSI install with a transforms file

```PowerShell
Execute-MSI -Action 'Install' -Path 'Adobe_Reader_11.0.0_EN.msi' -Transform 'Adobe_Reader_11.0.0_EN_01.mst'
```

### Install a patch

```PowerShell
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'
```

### Uninstall an MSI

```PowerShell
Execute-MSI -Action Uninstall -FilePath '{5708517C-59A3-45C6-9727-6C06C8595AFD}'
```

### Uninstall a number of msi codes

```PowerShell
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{B234DC00-1003-47E7-8111-230AA9E6BF10}" <# Last example cannot have a comma after the double quotes #>`
| % { Execute-MSI -Action 'Uninstall' -Path "$_" } <# foreach item, uninstall #>
```

### Run a vbscript

```PowerShell
Execute-Process -Path "cscript.exe" -Parameters "$dirFiles\whatever.vbs"
```

### Copy files to all user profiles

Grabbed from here: http://psappdeploytoolkit.com/forums/topic/copy-file-to-all-users-currently-logged-in-and-for-all-future-users/

```PowerShell
$ProfilePaths = Get-UserProfiles | Select-Object -ExpandProperty 'ProfilePath'
ForEach ($Profile in $ProfilePaths) {
    Copy-File -Path "$dirFiles\Example\example.ini" -Destination "$Profile\Example\To\Path\"
}
```

### Remove registry key

```PowerShell
Remove-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Macromedia\FlashPlayer\SafeVersions' -Recurse
```

# Remove a specific reg key item from  a 'folder'

```PowerShell
Remove-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'RunAppInstall'
```

### Create a registry key

```PowerShell
Set-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\LMKR\Licensing' -Name 'LMKR_LICENSE_FILE' -Value '@license'-Type String -ContinueOnError:$True
```

### Set an HKCU key for all users including the default profile

```PowerShell
[scriptblock]$HKCURegistrySettings = {
    Set-RegistryKey -Key 'HKEY_CURRENT_USER\SOFTWARE\Classes\AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9' -Name 'NoOpenWith' -Value '""'-Type String -ContinueOnError:$True
}
Invoke-HKCURegistrySettingsForAllUsers -RegistrySettings $HKCURegistrySettings
```

### Import a .reg key

```PowerShell
Execute-Process -FilePath "$envSystemRoot\reg.exe" -Parameters "/s `"$dirFiles\name-of-reg-export.reg`""
```

### Pause a script

```PowerShell
Start-Sleep -Seconds 120
```

### Copy and overwrite a file

```PowerShell
Copy-File -Path "$dirSupportFiles\mms.cfg" -Destination "C:\Windows\SysWOW64\Macromed\Flash\mms.cfg"
```

### Delete a file

```PowerShell
Remove-File -Path "$envCommonDesktop\GeoGraphix Seismic Modeling.lnk"
```


## Make an install marker reg key for custom detections

#for e.g. below would create something like:
#HKLM:\SOFTWARE\PSAppDeployToolkit\InstallMarkers\Microsoft_KB2921916_1.0_x64_EN_01
Set-RegistryKey -Key "$configToolkitRegPath\$appDeployToolkitName\InstallMarkers\$installName"

## While loop pause (incase app installer exits immediately)

#pause until example reg key
While(!(test-path -path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{product-code-hereD}")) {
                sleep 5;
                Write-Log -Message "$appVendor - $appName - $appVersion is still not finished installing, sleeping another 5" -Source $deployAppScriptFriendlyName;
}
#pause until example file
While(!(test-path -path "$envCommonDesktop\Example Shortcut.lnk")) {
                sleep 5;
                Write-Log -Message "$appVendor - $appName - $appVersion is still not finished installing, sleeping another 5" -Source $deployAppScriptFriendlyName;
}

##***To Create a shortcut***

New-Shortcut -Path "$envCommonPrograms\My Shortcut.lnk" `
    -TargetPath "$envWinDir\system32\notepad.exe" `
    -Arguments "--example-argument --example-argument-two" `
    -Description 'Notepad' `
    -WorkingDirectory "$envHomeDrive\$envHomePath"

## Modify ACL on a file

#first load the ACL
$acl_to_modify = "$envProgramData\Example\File.txt"
$acl = Get-Acl "$acl_to_modify"
#add another entry to the ACL list (in this case, add all users to have full control)
$ar = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "None", "None", "Allow")
$acl.SetAccessRule($ar)
#re-write the acl on the target file
Set-Acl "$acl_to_modify" $acl

## Modify ACL on a folder

$folder_to_change = "$envSystemDrive\Example_Folder"
$acl = Get-Acl "$folder_to_change"
$ar = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($ar)
Set-Acl "$folder_to_change" $acl  

## Add to environment variables (specifically PATH in this case)

# The first input in the .NET code can have Path subtituted for any other environemnt variable name (gci env: to see what is presently set)

$path_addition = "C:\bin"
#add $path_addition to permanent system wide path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $path_addition, "Machine")
#add $path_addition to permanent user specific path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $path_addition, "User")
#add $path_addition to the process level path only (i.e. when you quit script, it will no longer be applied)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $path_addition, "Process")
#.NET 4.x comparison/install
$version_we_require = [version]"4.5.2"
$version_we_want_path = "$dirFiles\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
$install_params = "/q /norestart"
if((Get-RegistryKey "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Value Version) -lt $version_we_require) {
    Write-Log -Source $deployAppScriptFriendlyName -Message ".NET version is < [string]$version_we_require, installing"
    Execute-Process -Path "$version_we_want_path" -Parameters "$install_params" -WaitForMSIExec:$true
}
#exit codes for reboot required
#soft reboot <- will not 'force' restart, and sccm will progress past, but will nag to restart afterward
Exit-Script -ExitCode 3010
#hard reboot <- does not 'force' restart, but sccm won't proceed past any pre-reqs without reboot
Exit-Script -ExitCode 1641
##Create Active Setup to Update User Settings
#1
Copy-File -Path "$dirFiles\Example.exe" -Destination "$envProgramData\Example"
Set-ActiveSetup -StubExePath "$envProgramData\Example\Example.exe" `
    -Description 'AutoDesk BIM Glue install' `
    -Key 'Autodesk_BIM_Glue_Install' `
    -ContinueOnError:$true
#2
Copy-File -Path "$dirSupportFiles\LyncUserSettings.cmd" -Destination "$envWindir\Installer\LyncUserSettings.cmd"
Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "" -Value "{90150000-012B-0409-0000-0000000FF1CE}" -Type String
Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "ComponentID" -Value "{90150000-012B-0409-0000-0000000FF1CE}" -Type String
Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "Version" -Value "15,0,4420,1017" -Type String
Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "StubPath" -Value "$envWindir\Installer\LyncUserSettings.cmd" -Type String
Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "Locale" -Value "EN" -Type String
#for reference, I've included the LyncUserSettings.cmd file as a springboard in this gist 

## function to assist finding uninstall strings, msi codes, display names of installed applications
# paste into powershell window (or save in (powershell profile)[http://www.howtogeek.com/50236/customizing-your-powershell-profile/]
# usage once loaded: 'Get-Uninstaller chrome'

function Get-Uninstaller {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name
  )
 
  $local_key     = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
  $machine_key32 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
  $machine_key64 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
 
  $keys = @($local_key, $machine_key32, $machine_key64)
 
  Get-ItemProperty -Path $keys -ErrorAction 'SilentlyContinue' | ?{ ($_.DisplayName -like "*$Name*") -or ($_.PsChildName -like "*$Name*") } | Select-Object PsPath,DisplayVersion,DisplayName,UninstallString,InstallSource,InstallLocation,QuietUninstallString,InstallDate
}

## end of function