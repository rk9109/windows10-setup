Import-Module Boxstarter.Chocolatey

# Get Credentials
$cred = Get-Credential domain\username

# Create + Install Package
New-PackageFromScript -Source scripts\install-general.ps1 -PackageName InstallGeneral
Install-BoxstarterPackage -Package InstallGeneral -Credential $cred
