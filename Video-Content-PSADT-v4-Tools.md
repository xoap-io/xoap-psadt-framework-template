# Introduction

The PowerShell AppDeployToolkit was upgraded to version 4. The new version has a lot of new features and improvements. This article will cover the new features and improvements in version 4.

## Prerequisites

- PowerShell 5.1 or PowerShell (Core) 7.4
- Windows 10 (1809) or later
- Windows 11 (21H2) or later
- Windows Server 2016 (1607) or later

## Installation

You can install the PowerShell AppDeployToolkit from the PowerShell Gallery. To install the PowerShell AppDeployToolkit, run the following command:

```powershell
Install-Module PSAppDeployToolkit.Tools -Scope CurrentUser -AllowPreRelease
```

or download the toolkit directly from GitHub: [Releases](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit.Tools/releases/latest)

## Get started

To get started with the PowerShell AppDeployToolkit.Tools, you can use the following example:

Test-ADTCompatibility

```powershell
Test-ADTCompatibility -FilePath .\Deploy-Application.ps1 -Format Grid
```

Convert-ADTDeployment

```Powershell
Convert-ADTDeployment -Path .\Deploy-Application.ps1
```

or

```Powershell
Convert-ADTDeployment -Path .\PackageFolder
```

## Known Limitations

-Known toolkit variables such as $appName are copied over to the hashtable used to create $adtSession.
- The main Install/Uninstall/Repair scriptblocks are converted and copied over to the new script.
- Any other custom variable/function declarations or other code outside of these blocks will not be transferred.
- Files and SupportFiles content will be transferred if a package folder is supplied as the path rather than a Deploy-Application.ps1 file.
- Config.xml changes will not be ported over to the new .psd1 files.
- Customized assets/banners are not currently copied over.
