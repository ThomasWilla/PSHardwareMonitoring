
#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path  "C:\Users\ThomasWilla\OneDrive - Willa\PowerShell\PSLib\PSHardwareMonitoring\Public\*.ps1" -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

#Initialisation Default Class Instance

Export-ModuleMember -Function $Public.Basename
$Global:DEFAULT_IN = [HardwareMonitor]::new() 

Write-Host "Please Set the Mesurement Components with Set-HWMeasuremetComponents, Default are CPU:Enabled, GPU:Disabled"

#Export-ModuleMember -Function $Public.Basename