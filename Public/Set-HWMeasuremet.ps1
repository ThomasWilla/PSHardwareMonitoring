function Set-HWMeasuremet{

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('enabled','disabled')]
        [string]
        $CPU,
        [Parameter()]
        [ValidateSet('enabled','disabled')]
        [string]
        $GPU
    )

    switch ($CPU) {

        "enabled" {$DEFAULT_IN.EnableCPU = $true}
        "disabled" {$DEFAULT_IN.EnableCPU = $false}
    }

    switch ($GPU) {

        "enabled" {$DEFAULT_IN.EnableGPU = $true}
        "disabled" {$DEFAULT_IN.EnableGPU = $false}
    }


}