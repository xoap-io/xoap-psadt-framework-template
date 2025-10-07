# Introduction

The PowerShell AppDeployToolkit was upgraded to version 4. The new version has a lot of new features and improvements.

## Prerequisites

- PowerShell 5.1 or PowerShell (Core) 7.4
- Windows 10 (1809) or later
- Windows 11 (21H2) or later
- Windows Server 2016 (1607) or later

## Installation

You can install the PowerShell AppDeployToolkit from the PowerShell Gallery. To install the PowerShell AppDeployToolkit, run the following command:

```powershell
Install-Module -Name PSAppDeployToolkit -Scope CurrentUser
```

or download the toolkit directly from GitHub: [Releases](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/releases/latest). In this case you can put the folder in any location you like, but you have to specifically load the module.

```powershell
Import-Module .PATHTOTOOLKIT\PSAppDeployToolkit\
```

## Changes from v3 to v4

The following are the most important changes:

- Digitally signed PowerShell module
- Strongly typed and defined object types, no more PSCustomObjects, etc
- Now provides PowerShell 7 and ARM support
- Extensions supported as supplemental modules
- Custom action support for extensions on deployment start/finish
- Support for overriding config via the registry
- Backwards-compatibility with v3 deployment scripts
- New configuration format with .psd1 files
- Booleans replaces with switches
- Standardized filterting
- ScriptBlock variables, objects are piped to the scriptblock
- multiple values now accepted as arrays
- ErrorAction used as standard for all cmdlets
- WIM support

### Filename and command changes

| Old File Name                     | New File Name        | Description            |
|-------------------------------|-------------------------------|------------------------|
| Deploy-Application.ps1        | Invoke-AppDeployToolkit.ps1   | [Invoke-AppDeployToolkit(https://psappdeploytoolkit.com/docs/deployment-concepts/invoke-appdeploytoolkit)]|
| Deploy-Application.exe        | Invoke-AppDeployToolkit.exe   | [Invoke-AppDeployToolkit(https://psappdeploytoolkit.com/docs/deployment-concepts/invoke-appdeploytoolkit)]|
| AppDeployToolkitConfig.xml    | Config\Config.psd1            | [Configuration Settings(https://psappdeploytoolkit.com/docs/reference/config-settings)] |
| Was part of Config file       | Strings\Strings.psd1          | [Language Strings(https://psappdeploytoolkit.com/docs/reference/language-strings)]       |

| Old Name        | New Name / Details    |
|-----------------|-----------------------|
| Copy-File       | [Copy-ADTFile](https://psappdeploytoolkit.com/docs/reference/functions/Copy-ADTFile)         |
| Execute-Process | [Start-ADTProcess](https://psappdeploytoolkit.com/docs/reference/functions/Start-ADTProcess)     |
| Write-Log       | [Write-ADTLogEntry](https://psappdeploytoolkit.com/docs/reference/functions/Write-ADTLogEntry)     |

## Get started

To get started with the PowerShell AppDeployToolkit, you can use the following example:

```powershell
New-ADTTemplate -Destination C:\Temp\MyAppDeployment -Name "MyAppDeployment"
```

A v3 compatible deployment template can be created with this command:

```powershell
New-ADTTemplate -Destination C:\Temp\MyAppDeployment -Name "MyOldAppDeployment" -Version 3
```

### File Structure v4 template

Invoke-AppDeployToolkit.ps1             # PSADT Deployment PowerShell script
Invoke-AppDeployToolkit.exe             # PSADT Deployment executable (to easily launch the above script)

├───Files                               # Primary installation files#
├───SupportFiles                        # Supporting resources or assets
│
├───PSAppDeployToolkit                  # PSADT module files. Please do not modify anything under this folder.
│   PSAppDeployToolkit.psd1             # PSADT module manifest. Import this if you want to use the module in your own scripts.
│   PSAppDeployToolkit.psm1             # PSADT module script. Contains all the functions and logic.
│
├───PSAppDeployToolkit.Extensions       # PSADT Extensions module files. # TODO - write more on this
│   PSAppDeployToolkit.Extensions.psd1
│   PSAppDeployToolkit.Extensions.psm1
│
├───Assets
│   AppIcon.png                         # The icon to display in the PSADT User Interface
│   Banner.Classic.png                  # The banner to display in the PSADT Classic User Interface (not used for Fluent dialogs)
│
├───Config
│   config.psd1                         # PSADT configuration file
│
└───Strings
    └───<LanguageCode>
        strings.psd1                    # PSADT User Interface language strings for <LanguageCode>.
    strings.psd1                        # PSADT User Interface language strings for English.

### Why should you create acompatible version 3 template?

Very simple, you can just copy the contents of your old package.

> In this case be sure to adjust the following files, when you had custom settings in them:

- Config\Config.psd1
- Strings\Strings.psd1
- Assets\Banner.classic.png

> The new Fluent UI is disabled in compatibility mode.

### File Structure v3 template

Deploy-Application.ps1                   # PSADT Deployment PowerShell script
Deploy-Application.exe                   # PSADT Deployment executable (to easily launch the above script)

├───Files                               # Primary installation files
├───SupportFiles                        # Supporting resources or assets
│
├───AppDeployToolkit
│   └───PSAppDeployToolkit              # PSADT module files. Please do not modify anything under this folder.
│       └───PSAppDeployToolkit.psd1     # PSADT module manifest. Used to import the module. Import this if you want to use the module in your
│           PSAppDeployToolkit.psm1     # PSADT module script. Contains all the functions and logic.
│   AppDeployToolkitMain.ps1            # PSADT compatibility shim script. Used to restore v3 function wrappers.
│   AppDeployToolkitExtensions.ps1      # PSADT compatibility extensions scripts. Used for your custom v3 functions.
│
├───Assets
│   AppIcon.png                         # The icon to display in the PSADT User Interface
│   Banner.Classic.png                  # The banner to display in the PSADT Classic User Interface (not used for Fluent dialogs)
│
├───Config
│   config.psd1                         # PSADT configuration file
│
└───Strings
    └───<LanguageCode>
        strings.psd1                    # PSADT User Interface language strings for <LanguageCode>.
    strings.psd1                        # PSADT User Interface language strings for English.

> Depending on the complexitiy of your v3 packages with a lot of custom scripting it makes sense to use the v3 compatibility mode. For new packages and simple ones it definitely makes sense to stick to the new v4 structure.

## Deploy a package

To deploy a package, you can use the following example:

```powershell
Invoke-AppDeployToolkit.ps1 -DeploymentType [Install, Uninstall, Repair] -DeployMode [Silent, Interactive, NonInteractive]
```

Besides that the general parameters are still valid:

- -AllowRebootPassThru
- -TerminalServerMode
- -DisableLogging

## Customizing Deployments

The PowerShell AppDeployToolkit allows you to customize deployments. The following are the most important customization options that you can configure with config.psd1:

- Admin rights requirements
- MSI parameters
- Logging

## General packaging tips

The following are the most important tips for packaging:

### Add the module to your profile

On your packaging VM add the automatic loading of the new module to your profile:

```powershell
Import-Module PSAppDeployToolkit
```

This gives you intellisense in VSCode and makes it easier to work with the module. You can even test the commands in the console before you add them to your deployment script.

Example:

```powershell
Show-ADTInstallationProgress -WindowLocation Bottom -MessageAlignment Center -WindowTitle "This is a demo" -WindowSubtitle "for PSADT v4" -StatusMessage "This is working fine" -StatusMessageDetail "Progress"
```

### Toolkit Variables

If you want to access the toolkit variables during packaging the check if your commands are valid, do the following:

```powershell
Initialize-ADTModule
$psadtvars = Get-ADTEnvironmentTable
```

This will give you a list of all toolkit variables that you can access in your console.

```PowerShell
$psadtvars.envhomepath
```

With that in place you can now access the toolkit variables in your console.

### Don't use PowerShell ISE

There a re some issues with the Fluent UI in the PowerShell ISE. So it is recommended to use VSCode or the PowerShell console.


## Tools

The PowerShell AppDeployToolkit comes with a lot of tools. The following are the most important ones that you can donwload and install seperately.

> Those tools are still in preview, so be sure to test them in a test environment first.


