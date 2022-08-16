<#
.SYNOPSIS
	This script is a template that allows you to extend the toolkit with your own custom functions.
    # LICENSE #
    PowerShell App Deployment Toolkit - Provides a set of functions to perform common application deployment tasks on Windows.
    Copyright (C) 2017 - Sean Lillis, Dan Cunningham, Muhammad Mashwani, Aman Motazedian.
    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
.DESCRIPTION
	The script is automatically dot-sourced by the AppDeployToolkitMain.ps1 script.
.NOTES
    Toolkit Exit Code Ranges:
    60000 - 68999: Reserved for built-in exit codes in Deploy-Application.ps1, Deploy-Application.exe, and AppDeployToolkitMain.ps1
    69000 - 69999: Recommended for user customized exit codes in Deploy-Application.ps1
    70000 - 79999: Recommended for user customized exit codes in AppDeployToolkitExtensions.ps1
.LINK
	http://psappdeploytoolkit.com
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
[version]$appDeployExtScriptVersion = [version]'3.8.4'
[string]$appDeployExtScriptDate = '26/01/2021'
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

#region Deregister-Installation
Function Deregister-Installation
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
} Else {
	Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] invoked directly" -Source $appDeployToolkitExtName
}

##*===============================================
##* END SCRIPT BODY
##*===============================================
