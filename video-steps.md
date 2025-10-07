import-module .\PSAppDeployToolkit\

get-command -module PSAppDeployToolkit

Get-ADTApplication -Name *

Test-ADTUserIsBusy

Test-ADTUserIsBusy -Verbose

Show-ADTInstallationProgress -WindowLocation Bottom -MessageAlignment Center -WindowTitle "This is a demo" -WindowSubtitle "for PSADT v4" -StatusMessage "This is working fine" -StatusMessageDetail "Progress"

