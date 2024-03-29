﻿<#
.SYNOPSIS

PSAppDeployToolkit - Provides the ability to extend and customise the toolkit by adding your own functions that can be re-used.

.DESCRIPTION

This script is a template that allows you to extend the toolkit with your own custom functions.

This script is dot-sourced by the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.

PSApppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2023 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.EXAMPLE

powershell.exe -File .\AppDeployToolkitHelp.ps1

.INPUTS

None

You cannot pipe objects to this script.

.OUTPUTS

None

This script does not generate any output.

.NOTES

.LINK

https://psappdeploytoolkit.com
#>


[CmdletBinding()]
Param (
)

##*===============================================
##* VARIABLE DECLARATION
##*===============================================

# Variables: Script
[string]$appDeployToolkitExtName = 'PSAppDeployToolkitExt'
[string]$appDeployExtScriptFriendlyName = 'App Deploy Toolkit Extensions'
[version]$appDeployExtScriptVersion = [version]'3.9.2'
[string]$appDeployExtScriptDate = '02/02/2023'
[hashtable]$appDeployExtScriptParameters = $PSBoundParameters

##*===============================================
##* FUNCTION LISTINGS
##*===============================================

#region Register-Installation
Function Register-Installation
{
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'IsInstalled' -Value 1 -Type DWord
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptName' -Value "$appName" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptVendor' -Value "$appVendor" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptVersion' -Value "$appVersion" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptArch' -Value "$appArch" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptLanguage' -Value "$appLang" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptRevision' -Value "$appRevision" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptVersion' -Value "$appScriptVersion" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptDate' -Value "$appScriptDate" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'ScriptAuthor' -Value "$appScriptAuthor" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'PSADTVersion' -Value "$appDeployMainScriptVersion" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'InstallationDateTime' -Value "$currentDateTime" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'InstallationTimeZone' -Value "$currentTimeZoneBias" -Type String
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'InstallationSource' -Value "$scriptParentPath" -Type String
	$logFile = "{0}{1}" -f $logDirectory, $logName
	Set-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName" -Name 'LogFile' -Value "$logFile" -Type String
}
#endregion

#region Unregister-Installation
Function Unregister-Installation
{
	Remove-RegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\PSADT\InstalledApps\$PackageName"
}
#endregion

##*===============================================
##* END FUNCTION LISTINGS
##*===============================================

##*===============================================
##* SCRIPT BODY
##*===============================================

If ($scriptParentPath) {
    Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] dot-source invoked by [$(((Get-Variable -Name MyInvocation).Value).ScriptName)]" -Source $appDeployToolkitExtName
}
Else {
    Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] invoked directly" -Source $appDeployToolkitExtName
}

##*===============================================
##* END SCRIPT BODY
##*===============================================
