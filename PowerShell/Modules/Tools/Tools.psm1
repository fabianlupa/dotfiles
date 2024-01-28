function New-EnvFile {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$FilePath = "$HOME\Documents\PowerShell\env.ps1"
    )

    if (Test-Path $FilePath) {
        throw "File already exists"
    }

    [String[]] $Variables = @(
        "`$FLMountPNetworkMountLetter",
        "`$FLMountPUsername",
        "`$FLMountPRootPath"
    )

    foreach ($Variable in $Variables) {
        Add-Content -Path $FilePath "$Variable = `"`""
    }
}

function Mount-P {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$NetworkMountLetter = $FLMountPNetworkMountLetter,
        [Parameter()]
        [string]$RootPath = $FLMountPRootPath,
        [Parameter()]
        [string]$UserName = $FLMountPUsername
    )

    New-PSDrive -Name $NetworkMountLetter -PSProvider "FileSystem" -Root $RootPath -Persist -Scope Global -Credential $UserName
}

function Remove-MountP {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$NetworkMountLetter = $FLMountPNetworkMountLetter
    )
    Remove-PSDrive -Name $NetworkMountLetter
}

Export-ModuleMember New-EnvFile
Export-ModuleMember Mount-P
Export-ModuleMember Remove-MountP
