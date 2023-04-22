<#
Sets the theme based on the current time. Indented to be scheduled in Windows Task Scheduler.
#>

using module LightSwitch

param(
    [Parameter()]
    [int]$DayTime = 9,
    [Parameter()]
    [int]$NightTime = 19
)

$CurrentHour = (Get-Date).Hour
$CurrentTheme = Get-Theme
$NewTheme = $CurrentTheme

if ($CurrentHour -ge $DayTime -and $CurrentHour -lt $NightTime) {
    $NewTheme = [Theme]::Light
}
else {
    $NewTheme = [Theme]::Dark
}

if ($NewTheme -ne $CurrentTheme) {
    Set-Theme -Theme $NewTheme
}
