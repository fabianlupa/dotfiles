$EnvPath = "$PSScriptRoot\env.ps1"
if (Test-Path $EnvPath) {
    . $EnvPath
}

Import-Module LightSwitch
Import-Module Tools

Set-Alias st Switch-Theme
Set-Alias mountp Mount-P
Set-Alias unmountp Remove-MountP

# Disable italics in autocomplete
set-psreadlineoption -Colors @{ "InlinePrediction" = "`e[38;5;238m" }

# Disable italics in list headers
$PSStyle.Formatting.CustomTableHeaderLabel = $PSStyle.Formatting.TableHeader

# Wrap oh-my-posh init for asynchronous load
function prompt {
    $env:POSH_THEME = "~/AppData/Local/Programs/oh-my-posh/themes/agnoster.minimal.omp.json" 
    oh-my-posh init pwsh | Invoke-Expression
}
# oh-my-posh init pwsh | Invoke-Expression

$env:POSH_GIT_ENABLED = $true
