# Description: Boxstarter Script
# Author: Rinik Kumar


# Prevent Windows MAXPATH Limit
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force


# Temp Settings
Disable-UAC
Disable-MicrosoftUpdate


# Remove Windows Features
Disable-BingSearch
Disable-GameBarTips


# Remove Windows Bloatware
$bloatware = @(
    "Microsoft."
    "Microsoft."
    "Microsoft."
    "Microsoft."
)

Function Remove-Bloatware {
    # add parameter

    foreach ($bloat in $bloatware) {
        Write-Output "Removing $bloat"
        Get-AppxPackage -Name $bloat -AllUsers | Remove-AppxPackage -AllUsers
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $bloat | Remove-AppxProvisionedPackage -Online
    }
}


# Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux


Function Install-Git {
    choco install -y git -params '"/GitAndUnixToolsOnPath"'
    RefreshEnv
}

Function Install-Utilities {
    cup --cacheLocation="$ChocoCachePath" 7zip
    cup --cacheLocation="$ChocoCachePath" curl
    cup --cacheLocation="$ChocoCachePath" wget
    cup --cacheLocation="$ChocoCachePath" greenshot
}

Function Install-DevelopmentTools {
    cup --cacheLocation="$ChocoCachePath" atom
    cup --cacheLocation="$ChocoCachePath" vscode
    cup --cacheLocation="$ChocoCachePath" nodejs
    cup --cacheLocation="$ChocoCachePath" miniconda3
    cup --cacheLocation="$ChocoCachePath" docker-desktop
    cup --cacheLocation="$ChocoCachePath" microsoft-windows-terminal
}

Function Install-Applications {
    cup --cacheLocation="$ChocoCachePath" googlechrome
    cup --cacheLocation="$ChocoCachePath" slack
    cup --cacheLocation="$ChocoCachePath" discord
    cup --cacheLocation="$ChocoCachePath" bitwarden
}


# Install Packages
Install-Git
Install-Utilities
Install-DevelopmentTools
Install-Applications


# Update Hostname
$computerName = Read-Host 'Enter Hostname'
Rename-Computer -NewName $computerName


# Generate SSH Key
$email = Read-Host "Enter Email"
ssh-keygen -t rsa -b 4096 -C "$email"


# Clean C:\
del C:\eula*.txt
del C:\install.*
del C:\vcredist.*
del C:\vc_red.*


# Restore Temp Settings
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
