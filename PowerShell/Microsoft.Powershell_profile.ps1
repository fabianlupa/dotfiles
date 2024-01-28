$EnvPath = "$PSScriptRoot\env.ps1"
if (Test-Path $EnvPath) {
    . $EnvPath
}

Import-Module LightSwitch
Import-Module Tools

Set-Alias st Switch-Theme
Set-Alias mountp Mount-P
Set-Alias unmountp Remove-MountP

# Invoke-Expression (&starship init powershell)

oh-my-posh init pwsh | Invoke-Expression

$env:POSH_GIT_ENABLED = $true
