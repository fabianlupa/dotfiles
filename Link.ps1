<#
Creates symlinks for the PowerShell folder to $HOME\Documents\PowerShell
Requires execution as admin or enabled developer mode for the symlinks :(
#>

param(
    [Parameter()]
    [bool]$Unlink = $False
)

function New-Symlink() {
    param (
        [Parameter()]
        [string]$Path,
        [Parameter()]
        [string]$Target,
        [Parameter()]
        [bool]$SkipIfExists = $True
    )

    if ($SkipIfExists -eq $true -and (Test-Path $Path) -eq $true -and (Get-Item $Path).LinkType -eq "SymbolicLink") {
        Write-Output "Skipping link to $Target as a symbolic link already exists on $Path"
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target
    }
}

$PowerShellHomeFolder = "$HOME\Documents\PowerShell"
$VSCodeSettingsPath = "$env:AppData\Code\User\settings.json"

if ($Unlink -eq $False) {
    New-Symlink -Path $PowerShellHomeFolder "$PSScriptRoot\PowerShell"
    New-Symlink -Path $VSCodeSettingsPath "$PSScriptRoot\VSCode\settings.json"
}
else {
    if ((Get-Item $PowerShellHomeFolder).LinkType -eq "SymbolicLink") {
        Remove-Item $PowerShellHomeFolder
    }

    if ((Get-Item $VSCodeSettingsPath).LinkType -eq "SymbolicLink") {
        Remove-Item $VSCodeSettingsPath
    }
}
