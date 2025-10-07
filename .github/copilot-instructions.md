# XOAP PSADT Framework Template - AI Coding Instructions

## Project Overview
This repository provides PowerShell App Deployment Toolkit (PSADT) templates for automated application deployment in enterprise environments. It contains both v3 and v4 templates, with v4 being the modern, digitally-signed module-based approach.

## Architecture & Key Components

### Dual Template Structure
- **PSAppDeployToolkit_Template_v3/**: Legacy v3 framework using `Deploy-Application.ps1`
- **PSAppDeployToolkit_Template_v4/**: Modern v4 framework using `Invoke-AppDeployToolkit.ps1`
- Always prefer v4 for new deployments unless specifically maintaining v3 scripts

### V4 Framework Core Files (Primary Focus)
```
PSAppDeployToolkit_Template_v4/
├── Invoke-AppDeployToolkit.ps1     # Main deployment script (replaces Deploy-Application.ps1)
├── Invoke-AppDeployToolkit.exe     # Compiled wrapper for execution
├── Config/config.psd1              # Configuration (replaces AppDeployToolkitConfig.xml)
├── PSAppDeployToolkit/             # Core module (v4.0.5)
├── PSAppDeployToolkit.Extensions/  # Local extensions module
├── Files/                          # Application installers go here
└── Strings/                        # Localization files
```

## Development Patterns

### V4 Function Structure
All deployment logic uses three standard functions in `Invoke-AppDeployToolkit.ps1`:
```powershell
function Install-ADTDeployment {
    # Pre-Install, Install, Post-Install phases
}
function Uninstall-ADTDeployment {
    # Pre-Uninstall, Uninstall, Post-Uninstallation phases  
}
function Repair-ADTDeployment {
    # Pre-Repair, Repair, Post-Repair phases
}
```

### Module Loading & Session Management
- V4 uses `Import-Module` with specific GUID validation (`8c3c366b-8606-4576-9f2d-4051144f7ca2`)
- Session management via `Open-ADTSession` and `Close-ADTSession`
- Extensions loaded automatically from `PSAppDeployToolkit.Extensions/`

### Configuration Approach
- V4: PowerShell data files (`.psd1`) in `Config/config.psd1`
- V3: XML configuration in `AppDeployToolkitConfig.xml`
- Configuration covers MSI parameters, UI settings, logging, and paths

## Command Patterns

### V4 Function Naming Convention
All functions use `ADT` prefix: `Start-ADTProcess`, `Show-ADTInstallationWelcome`, `Install-ADTMSUpdates`

### Common V4 Deployment Commands
```powershell
# Process management
Show-ADTInstallationWelcome -CloseProcesses 'notepad,calc' -CloseProcessesCountdown 60

# MSI handling  
Start-ADTMsiProcess -Action Install -FilePath "$envDirFiles\app.msi"

# Process execution
Start-ADTProcess -FilePath "setup.exe" -ArgumentList '/quiet'

# User interface
Show-ADTInstallationProgress -StatusMessage "Installing Application..."
```

### Environment Variables (Both V3/V4)
Standard path variables available in all scripts:
- `$envProgramFiles` → `C:\Program Files`
- `$envProgramFilesX86` → `C:\Program Files (x86)`  
- `$envProgramData` → `C:\ProgramData`
- `$envCommonDesktop` → `C:\Users\Public\Desktop`
- `$envWinDir` → `C:\Windows`

## File Organization

### Application Files Structure
- Place installers in `Files/` directory
- Reference as `$envDirFiles\installer.msi`
- Supporting files go in `SupportFiles/` 

### Extension Development
- Custom functions in `PSAppDeployToolkit.Extensions/PSAppDeployToolkit.Extensions.psm1`
- Follow module manifest pattern in `.psd1`
- Extensions support session callbacks: `Add-ADTSessionStartingCallback`

## Execution Methods

### V4 Command Line Options
```bash
# Standard installation
Invoke-AppDeployToolkit.ps1

# Silent uninstall  
Invoke-AppDeployToolkit.ps1 -DeploymentType Uninstall -DeployMode Silent

# Using compiled wrapper
Invoke-AppDeployToolkit.exe -AllowRebootPassThru

# Custom script execution
Invoke-AppDeployToolkit.exe Custom-Script.ps1 -DeploymentType Install
```

## Error Handling & Logging

### V4 Error Management
- Uses `$ErrorActionPreference = 'Stop'` with try/catch blocks
- Centralized error handling in main script
- Exit codes: 60000-68999 (built-in), 69000-69999 (user customizable)

### Logging Configuration
- CMTrace-compatible logs by default (`LogStyle = 'CMTrace'`)
- Log paths: `$envWinDir\Logs\Software` (admin) or `$envProgramData\Logs\Software` (non-admin)
- Debug logging controlled via `LogDebugMessage` setting

## Key Conventions

### Variable Declaration (V3 Pattern)
```powershell
[string]$appVendor = 'CompanyName'
[string]$appName = 'ApplicationName'  
[string]$appVersion = '1.0.0'
[string]$appArch = 'x64'
[string]$appTags = 'Productivity,Office'
```

### MSI Zero-Config Deployment
Both frameworks support automatic MSI detection and deployment when MSI files are in the `Files/` directory.

### Deployment Phase Markers
Use consistent phase markers for maintainability:
```powershell
##================================================
## MARK: Pre-Install / Install / Post-Install
##================================================
```

When modifying deployment scripts, always maintain the three-phase structure and use appropriate ADT functions for process management, user interaction, and logging.