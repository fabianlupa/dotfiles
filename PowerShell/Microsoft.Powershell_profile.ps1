Import-Module LightSwitch

Set-Alias st Switch-Theme

# Invoke-Expression (&starship init powershell)

oh-my-posh init pwsh | Invoke-Expression

$env:POSH_GIT_ENABLED = $true