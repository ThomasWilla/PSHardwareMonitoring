#Hardware Monitoring

class HardwareMonitor {

    #properties

    #[System.Management.Automation.Runspaces.PSSession] $RemoteSession
    [System.Collections.ArrayList] $HardwareMonitorLog
    [String] $LastErrorMessage
    [String]$OpenHWMonitoringDLLVersion
    [Bool] $EnableCPU = $true
    [Bool] $EnableGPU = $false
    [System.Object]$Temperatures
    hidden [string] $HardwareMonitorDLLPath = "\DLL\OpenHardwareMonitorLib.dll"
    [System.Object] $PCHARDWARE



    #Constructor
    HardwareMonitor(){
        $this.CheckHardwareMonitoringDLL()
        }

    hidden [void] CheckHardwareMonitoringDLL()
    {
        $this.InitialLog()

        try{
            Get-Item  -Path "$($PSScriptRoot)$($this.HardwareMonitorDLLPath)" -ErrorAction  Stop
            $this.OpenHWMonitoringDLLVersion=(Get-Item  -Path "$($PSScriptRoot)$($this.HardwareMonitorDLLPath)").VersionInfo.FileVersion      
        }  
    
        catch{
            $this.DoLog("Error","Hardware Monitoring File was not Found")
            throw $_.Exception.Message
        }

        try{
            Get-Item -Stream Zone.Identifier -Path "$($PSScriptRoot)$($this.HardwareMonitorDLLPath)" -ErrorAction  Stop
            Unblock-File "$($PSScriptRoot)$($this.HardwareMonitorDLLPath)" 
        }
        
        catch{
            $this.DoLog("Information","File was tested on Zone.Identifier and was clear")
            $this.InitialHardWareMonitoringObject()
           

        }
    }#End Constructor


    hidden [void] InitialLog(){
        $this.HardwareMonitorLog = New-Object System.Collections.ArrayList
    }#End Initial Log
           
    
    [void] DoLog($LogLevel,$LogMessage){
        
        $LogEntry = [pscustomobject]@{
            Time=(Get-Date)
            Level= $LogLevel
            Message= $LogMessage
        }
   

        switch ($Loglevel) {
            "Error" {
                    $this.LastErrorMessage = "$($logentry.Time) | $($LogEntry.Message)"
                    $this.HardwareMonitorLog.Add($LogEntry)   
                }
            Default {$this.HardwareMonitorLog.Add($LogEntry)}
        }
    
    }#End Log
    
    hidden [void] InitialHardWareMonitoringObject(){
        try{
            [System.Reflection.Assembly]::LoadFile("$($PSScriptRoot)$($this.HardwareMonitorDLLPath)") | Out-Null
            $this.PCHARDWARE = New-Object OpenHardwareMonitor.Hardware.Computer
            $this.PCHARDWARE.open()
            $this.DoLog("Information","Class OpenHardwareMonitor Loaded")
            }
        catch{
            $this.DoLog("Error","Could not load OpenHardwareMonitorLib.dll")
            throw $_.Exception.Message
        }

    }#End Initial .Net Class Hwardware monitoring
    

    hidden [void] SetMeasuremetComponents(){
        $this.PCHARDWARE.CPUEnabled = $this.EnableCPU
        $this.PCHARDWARE.GPUEnabled = $this.EnableGPU
    }

    [System.Object] GetMeasurementValues(){

        $this.SetMeasuremetComponents()
        $this.PCHARDWARE.Hardware.Update()
        $this.Temperatures = $this.PCHARDWARE.Hardware.Sensors | Select-Object SensorType,Name,Index,Min,Max,Value | Where-Object {$_.SensorType -eq "Temperature"}
        return $this.Temperatures 

    }


 
    

} #Class End

