function New-HWCustomObject {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $CustomObjectName
)
    New-Variable -Name $CustomObjectName -Value ([HardwareMonitor]::new()) -Scope Global
    
}