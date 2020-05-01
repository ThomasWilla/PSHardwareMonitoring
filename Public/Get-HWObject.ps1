function Get-HWObject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('ShowObject','ShowMembers')]
        [String]
        $Show
    )
switch ($Show) {
    'ShowObject' { $DEFAULT_IN }
    'ShowMembers' {$DEFAULT_IN | Get-Member}
}
 
}