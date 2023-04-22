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
        [string]$Target
    )
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}

$PowerShellHomeFolder = "$HOME\Documents\PowerShell"

if ($Unlink -eq $False) {
    New-Symlink -Path $PowerShellHomeFolder "$PSScriptRoot\PowerShell"
}
else {
    if ((Get-Item $PowerShellHomeFolder).LinkType -eq "SymbolicLink") {
        Remove-Item $PowerShellHomeFolder
    }
}
