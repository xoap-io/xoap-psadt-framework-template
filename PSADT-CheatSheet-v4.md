# PSADT v4 Cheat Sheet

## Variables

```PowerShell
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

## How to Deploy

### Deploy an application for installation

```PowerShell
Invoke-AppDeployToolkit.ps1
```

### Deploy an application for uninstallation in silent mode

```PowerShell
Invoke-AppDeployToolkit.ps1 -DeploymentType Uninstall -DeployMode Silent
```

### Deploy an application for uninstallation using PowerShell x86, suppressing the PowerShell console window and deploying in silent mode.

```PowerShell
Invoke-AppDeployToolkit.exe /32 -DeploymentType Uninstall -DeployMode Silent
```

### Deploy an application for installation, suppressing the PowerShell console window and allowing reboot codes to be returned to the parent process.

```PowerShell
Invoke-AppDeployToolkit.exe -AllowRebootPassThru
```

### Deploy an application with a custom name instead of Invoke-AppDeployToolkit.ps1.

```PowerShell
Invoke-AppDeployToolkit.exe Custom-Script.ps1
```

### Remove an application with a custom name and custom location for the script file.

```PowerShell
Invoke-AppDeployToolkit.exe -Command C:\Testing\Custom-Script.ps1 -DeploymentType Uninstall
```

## Toolkit Parameters

### Deployment Type

```PowerShell
-DeploymentType Install ## default, options:  Install, Uninstall, Repait
```

### Deploy Mode

```PowerShell
-DeployMode Interactive ## default, options:  Interactive, Silent, NonInteractive
```

### Allow Reboot Pass Thru

```PowerShell
-AllowRebootPassThru
```

### Terminal Server Mode

```PowerShell
-TerminalServerMode
```

### Disable Logging

```PowerShell
-DisableLogging
```

## Examples of exe installers

```PowerShell
Start-ADTProcess -FilePath "setup.exe" -ArgumentList '/quiet'
Start-ADTProcess -FilePath "$envDirFiles\setup.exe" -ArgumentList '/S' -WindowStyle 'Hidden'
```

### Open Notepad.exe and don't wait for it to close

```PowerShell
Start-ADTProcess -FilePath -Path "$envSystemRoot\notepad.exe" -NoWait
```

## Examples of msi installers

```PowerShell
Start-ADTMsiProcess -Action 'Install' -FilePath "$envDirFiles\Bin\setup.msi" -ArgumentList 'REBOOT=ReallySuppress /QN'
Start-ADTMsiProcess -Action 'Install' -FilePath 'Discovery 2015.1.msi'
```

###  MSI install with a transforms file

```PowerShell
Start-ADTMsiProcess -Action 'Install' -FilePath 'Adobe_Reader_11.0.0_EN.msi' -Transforms 'Adobe_Reader_11.0.0_EN_01.mst'
```

### Install a patch

```PowerShell
Start-ADTMsiProcess -Action 'Patch' -FilePath 'Adobe_Reader_11.0.3_EN.msp'
```

### Uninstall an MSI

```PowerShell
Start-ADTMsiProcess -Action 'Uninstall' -FilePath '{5708517C-59A3-45C6-9727-6C06C8595AFD}'
```

### Uninstall a number of msi codes

```PowerShell
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{B234DC00-1003-47E7-8111-230AA9E6BF10}" <# Last example cannot have a comma after the double quotes #>`
| % { Start-ADTMsiProcess -Action 'Uninstall' -FilePath "$_" } <# foreach item, uninstall #>
```

### Run a vbscript

```PowerShell
Start-ADTProcess -FilePath "cscript.exe" -Start-ADTProcess -FilePath "setup.exe" -ArgumentList '/quiet'  -WaitForMsiExec:$true
 "$envDirFiles\whatever.vbs"
```

### Copy files to all user profiles

```PowerShell
Invoke-ADTAllUsersRegistryAction -ScriptBlock {
    Copy-ADTFile -Path "$envDirFiles\Example\example.ini" -Destination "$($adtSession).Profile)\Example\To\Path\"
}
```

### Remove registry key

```PowerShell
Remove-ADTRegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Macromedia\FlashPlayer\SafeVersions' -Recurse
```

# Remove a specific reg key item from  a 'folder'

```PowerShell
Remove-ADTRegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'RunAppInstall'
```

### Create a registry key

```PowerShell
Set-ADTRegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\LMKR\Licensing' -Name 'LMKR_LICENSE_FILE' -Value '@license'-Type String
```

### Set an HKCU key for all users including the default profile

```PowerShell
Invoke-ADTAllUsersRegistryAction {
    Set-ADTRegistryKey -Key 'HKEY_CURRENT_USER\SOFTWARE\Classes\AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9' -Name 'NoOpenWith' -Value '""' -Type String -SID $_.SID
}
```

### Import a .reg key

```PowerShell
Start-ADTProcess -FilePath "$SystemRoot\reg.exe" -ArgumentList "/s `"$envDirFiles\name-of-reg-export.reg`""
```

### Pause a script

```PowerShell
Start-Sleep -Seconds 120
```

```PowerShell
Copy-ADTFile -Path "$envSupportFiles\mms.cfg" -Destination "C:\Windows\SysWOW64\Macromed\Flash\mms.cfg"
```

### Delete a file

```PowerShell
Remove-File -Path "$envCommonDesktop\GeoGraphix Seismic Modeling.lnk"
```

