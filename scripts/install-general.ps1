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

Function Remove-Bloatware {
    $bloatware = @(
        "Microsoft.3DBuilder"
        "Microsoft.Appconnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.BingTravel"
        "Microsoft.FreshPaint"
        "Microsoft.GamingServices"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftPowerBIForWindows"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.MicrosoftStickyNotes"
        "Microsoft.MinecraftUWP"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Messaging"
        "Microsoft.Print3D"
        "Microsoft.Wallet"
        "Microsoft.Windows.Photos"
        "Microsoft.WindowsAlarms"
        "Microsoft.WindowsCalculator"
        "Microsoft.WindowsCamera"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.Xbox.TCUI"
        "Microsoft.XboxApp"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.YourPhone"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "Microsoft.CommsPhone"
        "Microsoft.ConnectivityStore"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsReadingList"
        "Microsoft.MixedReality.Portal"
        "Microsoft.ScreenSketch"
        "Microsoft.YourPhone"
        "Microsoft.Advertising.Xaml"
    )

    foreach ($bloat in $bloatware) {
        Write-Output "Removing $bloat"
        Get-AppxPackage -Name $bloat -AllUsers | Remove-AppxPackage -AllUsers
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $bloat | Remove-AppxProvisionedPackage -Online
    }
}

Remove-Bloatware

# Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Install Ubuntu 18.04
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx
del ~/Ubuntu.appx

Function Install-Git {
    choco install -y git -params '"/GitAndUnixToolsOnPath"'
    RefreshEnv
}

Function Install-Utilities {
    choco upgrade --cacheLocation="$ChocoCachePath" 7zip
    choco upgrade --cacheLocation="$ChocoCachePath" curl
    choco upgrade --cacheLocation="$ChocoCachePath" wget
    choco upgrade --cacheLocation="$ChocoCachePath" greenshot
}

Function Install-DevelopmentTools {
    choco upgrade --cacheLocation="$ChocoCachePath" vcxsrv
}

Function Install-Applications {
    choco upgrade --cacheLocation="$ChocoCachePath" googlechrome
    choco upgrade --cacheLocation="$ChocoCachePath" slack
    choco upgrade --cacheLocation="$ChocoCachePath" discord
    choco upgrade --cacheLocation="$ChocoCachePath" bitwarden
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
