<#
Helper functions to set the theme in various applications and the OS
Original script by Shawn Keene
https://cmdrkeene.com/schedule-light-and-dark-mode/
#>

function Set-WindowsWallpaper {
    <#
    by Jose Espitia September 15, 2017
    https://www.joseespitia.com/2017/09/15/Set-WindowsWallpaper-powershell-function/
    #>

    param (
        [Parameter(Mandatory = $True)]
        # Provide path to image
        [string]$Image,
        # Provide wallpaper style that you would like applied
        [Parameter(Mandatory = $False)]
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style
    )

    $WallpaperStyle = switch ($Style) {
        "Fill" { "10" }
        "Fit" { "6" }
        "Stretch" { "2" }
        "Tile" { "0" }
        "Center" { "0" }
        "Span" { "22" }
    }

    if ($Style -eq "Tile") {
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force | Out-Null
    }
    else {
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force | Out-Null
    }

    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Params
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern int SystemParametersInfo (Int32 uAction,
                                                Int32 uParam,
                                                String lpvParam,
                                                Int32 fuWinIni);
}
"@

    $SpiSetDeskWallpaperAction = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02

    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    [Params]::SystemParametersInfo($SpiSetDeskWallpaperAction, 0, $Image, $fWinIni) | Out-Null
}

enum WindowsTheme {
    Light
    Dark
}

$WindowsThemeRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

function Get-WindowsTheme {
    $Value = Get-ItemPropertyValue -Path $WindowsThemeRegistryPath -Name "SystemUsesLightTheme"

    $Result = switch ($Value) {
        1 { [WindowsTheme]::Light }
        0 { [WindowsTheme]::Dark }
        Default { throw "Invalid current theme" }
    }

    return $Result
}

function Set-WindowsTheme {
    param (
        [Parameter(Mandatory = $True)]
        [WindowsTheme]$Theme
    )

    if (!(Test-Path $WindowsThemeRegistryPath)) { throw "Theme registry path not found" } 

    $Value = switch ($Theme) {
        ([WindowsTheme]::Light) { 1 }
        ([WindowsTheme]::Dark) { 0 }
        Default { throw "Invalid theme" }
    }

    New-ItemProperty -Path $WindowsThemeRegistryPath -Name "SystemUsesLightTheme" -Value $Value -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $WindowsThemeRegistryPath -Name "AppsUseLightTheme" -Value $Value -PropertyType DWORD -Force | Out-Null

    # Unfortunately changing the registry value does not update the task bar automatically anymore on Windows 11,
    # therefore restart explorer.exe
    Get-Process "explorer" | Stop-Process
}

enum SapTheme {
    Signature = 1
    SignatureHighContrastBlack = 2
    Classic = 32
    Corbu = 64
    BlueCrystal = 128
    Belize = 256
    BelizeHighContrastBlack = 512
    BelizeHighContrastWhite = 1024
    Quartz = 2048
    QuartzHighContrastBlack = 4096
    QuartzHighContrastWhite = 8192
    QuartzDark = 16384
}

function Set-SapTheme {
    param (
        [Parameter(Mandatory = $True)]
        [SapTheme]$Theme
    )

    New-ItemProperty -Path "HKCU:\Software\SAP\General\Appearance" -Name "SelectedTheme" -Value $Theme.Value__ -PropertyType DWORD -Force | Out-Null
}

enum EclipseTheme {
    Light
    Dark
}

function Set-EclipseTheme {
    param (
        [Parameter(Mandatory = $True)]
        [string]$WorkspacePath,
        [Parameter(Mandatory = $True)]
        [EclipseTheme]$Theme
    )

    $SearchPattern = "themeid=.*"
    $ThemeValue = switch ($Theme) {
        ([EclipseTheme]::Light) { "org.eclipse.e4.ui.css.theme.e4_default" }
        ([EclipseTheme]::Dark) { "org.eclipse.e4.ui.css.theme.e4_dark" }
    }
    $NewValue = "themeid=$ThemeValue"
    $FilePath = "$WorkspacePath\.metadata\.plugins\org.eclipse.core.runtime\.settings\org.eclipse.e4.ui.css.swt.theme.prefs"

    $Content = Get-Content $FilePath
    if ($Content -match $SearchPattern) {
        $Content = $Content -replace $SearchPattern, $NewValue
    }
    else {
        $Content = "$Content`r`n$NewValue"
    }

    Set-Content -Path $FilePath -Value $Content
}

function Switch-Theme {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Target[]]$Targets
    )

    if ($Targets.count -eq 0) {
        $Targets = Get-DefaultTargets
    }

    switch (Get-Theme) {
        ([Theme]::Light) { Set-Theme -Theme Dark -Targets $Targets }
        ([Theme]::Dark) { Set-Theme -Theme Light -Targets $Targets }
    }
}

enum Theme {
    Dark
    Light
}

enum Target {
    WindowsTheme
    WindowsWallpaper
    SapTheme
    EclipseTheme
}

function Get-DefaultTargets {
    return (
        [Target]::WindowsTheme,
        [Target]::WindowsWallpaper,
        [Target]::SapTheme,
        [Target]::EclipseTheme
    )
}

function Get-Theme {
    switch (Get-WindowsTheme) {
        ([WindowsTheme]::Light) { return [Theme]::Light }
        ([WindowsTheme]::Dark) { return [Theme]::Dark }
        Default { throw "Invalid current theme" }
    }
}
function Set-Theme {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [Theme]$Theme,
        [Parameter()]
        [Target[]]$Targets
    )

    if ($Targets.count -eq 0) {
        $Targets = Get-DefaultTargets
    }

    $DarkWallpaperPath = "C:\Windows\Web\Wallpaper\Windows\img19.jpg"
    $LightWallpaperPath = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"

    $EclipseWorkspacePath = "$HOME\workspace";

    foreach ($Target in $Targets) {
        switch ($Target) {
            ([Target]::WindowsTheme) { 
                if ($Theme -eq [Theme]::Dark) {
                    Set-WindowsTheme Dark
                }
                else {
                    Set-WindowsTheme Light
                }
            }
            ([Target]::WindowsWallpaper) { 
                if ($Theme -eq [Theme]::Dark) {
                    Set-WindowsWallpaper -Image $DarkWallpaperPath -Style Fill
                }
                else {
                    Set-WindowsWallpaper -Image $LightWallpaperPath -Style Fill
                }
            }
            ([Target]::SapTheme) { 
                if ($Theme -eq [Theme]::Dark) {
                    Set-SapTheme -Theme QuartzDark
                }
                else {
                    Set-SapTheme -Theme Quartz
                }
            }
            ([Target]::EclipseTheme) { 
                if ($Theme -eq [Theme]::Dark) {
                    Set-EclipseTheme -WorkspacePath $EclipseWorkspacePath -Theme Dark
                }
                else {
                    Set-EclipseTheme -WorkspacePath $EclipseWorkspacePath -Theme Light
                }
            }
            Default { throw "Unknown target" }
        }
    }

    switch ($Theme) {
        ([Theme]::Dark) { Write-Output "Night mode engaged" }
        ([Theme]::Light) { Write-Output "Let there be light" }
    }
}

Export-ModuleMember Get-Theme
Export-ModuleMember Set-Theme
Export-ModuleMember Switch-Theme
