Import-Module Boxstarter.Chocolatey

# Create + Install Package
New-PackageFromScript -Source scripts\install-general.ps1 -PackageName InstallGeneral
Install-BoxstarterPackage -Package InstallGeneral
